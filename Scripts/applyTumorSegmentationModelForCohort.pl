#/usr/bin/perl -w

use strict;

use Cwd 'realpath';
use File::Find;
use File::Basename;
use File::Path;
use File::Spec;
use FindBin qw($Bin);

my $usage = qq{

  Usage: applyTumorSegmentationModelForCohort.pl <inputDirectory> <outputDirectory>

 };

my ( $inputDirectory, $outputDirectory ) = @ARGV;


my $ANTSPATH = $ENV{ 'ANTSPATH' };
my $UTILPATH = $ENV{ 'UTILPATH' };

my $basedir = '/home/njt4n/share/Data/Tumor/BRATS/';

my $templatedir = '/home/njt4n/share/Data/Public/Kirby/SymmetricTemplate/';
my $templateLabels = "${templatedir}/S_templateJointLabels_6labels.nii.gz";
my $templateMask = "${templatedir}/S_templateMask.nii.gz";
my $clusterdir = "${basedir}/ClusterCenters/";

my $modeldir = "${basedir}/RandomForestModels/";

my @templates = ();
$templates[0] = "${templatedir}/S_template2_skullStripped_RESCALED.nii.gz";          #FLAIR
$templates[1] = "${templatedir}/S_template3_skullStripped_RESCALED.nii.gz";          #T1
$templates[2] = "${templatedir}/S_template3_skullStripped_RESCALED.nii.gz";          #T1
$templates[3] = "${templatedir}/S_template5_skullStripped_RESCALED.nii.gz";          #T2

my @suffixList = ( ".mha", ".nii.gz" );

###
##
## Might need to calculated the cluster centers or list them here for future use.
##
###

###
##
## Create feature images for each subject (send to cluster)
##
###

my @subjectdirs = <${inputDirectory}/*>;

for( my $i = 0; $i < @subjectdirs; $i++ )
  {
  print "****************************\n";
  print "$subjectdirs[$i]            \n";
  print "****************************\n";

  if( ! -d $subjectdirs[$i] )
    {
    next;
    }

  my @comps = split( '/', $subjectdirs[$i] );

  my $subjectID = ${comps[-1]};
  my @tmp = split( '_', $subjectID );
  my $name = $tmp[1];

  my $cohort = 'LG';
  if( ${comps[-1]} =~ m/HG/ )
    {
    $cohort = 'HG';
    }
  my $dataType = 'BRATS';
  if( ${comps[-1]} =~ m/Sim/ )
    {
    $dataType = 'SimBRATS';
    $name = "Sim${name}";
    }


  my $gmmModel = "${modeldir}/${dataType}_${cohort}_GMM.RData";
  my $mapmrfModel = "${modeldir}/${dataType}_${cohort}_MAP_MRF.RData";

  my $clusterFile = "${clusterdir}/${dataType}_${cohort}_CLUSTER_CENTERS.csv";
  open( CFILE, $clusterFile );
  my @clusters = <CFILE>;
  close( CFILE );
  for( my $c = 0; $c < @clusters; $c++ )
    {
    chomp( $clusters[$c] );
    }

  my @images = ();
  $images[0] = "${subjectdirs[$i]}/${subjectID}_FLAIR.nii.gz";
  $images[1] = "${subjectdirs[$i]}/${subjectID}_T1.nii.gz";
  $images[2] = "${subjectdirs[$i]}/${subjectID}_T1C.nii.gz";
  $images[3] = "${subjectdirs[$i]}/${subjectID}_T2.nii.gz";
  my $mask = "${subjectdirs[$i]}/${subjectID}_MASK.nii.gz";

  my $outputSubjectDirectory = "${outputDirectory}/${subjectID}/";
  if( ! -d $outputSubjectDirectory )
    {
    mkpath( $outputSubjectDirectory, {verbose => 0, mode => 0755} ) or
      die "Can't create output directory $outputSubjectDirectory\n\t";
    }
  my $outputPrefix = "${outputSubjectDirectory}/${subjectID}";

  my $coreLabel = 4;
  my $numberOfLabels = 7;
  if( $subjectID =~ m/Sim/ )
    {
    $coreLabel = 5;
    $numberOfLabels = 5;
    }

  my $commandFile = "${outputPrefix}ApplyModels.sh";

  open( FILE, ">${commandFile}" );
  print FILE "#!/bin/sh\n";
  print FILE "export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=4\n";

  print FILE "export LD_LIBRARY_PATH=";
  print FILE "\"/home/njt4n/share/Pkg/R/library/Rcpp/lib:";
  print FILE "/home/njt4n/share/Pkg/ANTsR/src/ANTS/ANTS-build/lib:";
  print FILE "/home/njt4n/share/Pkg/R/library/ANTsR/libs:";
  print FILE "\$LD_LIBRARY_PATH\"\n";
  print FILE "\n";

  ##
  #
  # Apply the GMM model
  #
  ##
  my @args = ( 'sh', "${UTILPATH}/../scripts/applyTumorSegmentationModel.sh",
                     '-m', $gmmModel,
                     '-d', 3,
                     '-x', $mask,
                     '-l', $coreLabel,
                     '-n', 'T1',
                     '-a', ${images[1]},
                     '-t', ${templates[1]},
                     '-c', ${clusters[1]},
                     '-n', 'FLAIR',
                     '-a', ${images[0]},
                     '-t', ${templates[0]},
                     '-c', ${clusters[0]},
                     '-n', 'T1C',
                     '-a', ${images[2]},
                     '-t', ${templates[2]},
                     '-c', ${clusters[2]},
                     '-n', 'T2',
                     '-a', ${images[3]},
                     '-t', ${templates[3]},
                     '-c', ${clusters[3]},
                     '-o', "${outputPrefix}_",
                     '-f', '0x2',
                     '-r', 1,
                     '-r', 3,
                     '-s', 2,
                     '-b', $numberOfLabels
                     );

  print FILE "\n@args\n";

  ##
  #
  # Apply the MAP-MRF model
  #
  ##

  my $warpedMask = "${outputPrefix}_SYMMETRIC_TEMPLATE_MASK_WARPED.nii.gz";

  @args = ( "${ANTSPATH}/antsApplyTransforms",
                  '-d', 3,
                  '-i', $templateMask,
                  '-r', $images[0],
                  '-o', $warpedMask,
                  '-n', 'MultiLabel',
                  '-t', "${outputPrefix}_ANTs_REGISTRATION1Warp.nii.gz",
                  '-t', "${outputPrefix}_ANTs_REGISTRATION0GenericAffine.mat"
                  );
  print FILE "\n@args\n";
  print FILE "${UTILPATH}/BinaryOperateImages 3 $mask and $warpedMask $warpedMask\n";

  @args = ( 'sh', "${UTILPATH}/../scripts/applyTumorSegmentationModel.sh",
                     '-m', $mapmrfModel,
                     '-d', 3,
                     '-u', $templateMask,
                     '-x', $warpedMask,
                     '-l', $coreLabel,
                     '-n', 'T1',
                     '-a', ${images[1]},
                     '-t', ${templates[1]},
                     '-c', ${clusters[1]},
                     '-n', 'FLAIR',
                     '-a', ${images[0]},
                     '-t', ${templates[0]},
                     '-c', ${clusters[0]},
                     '-n', 'T1C',
                     '-a', ${images[2]},
                     '-t', ${templates[2]},
                     '-c', ${clusters[2]},
                     '-n', 'T2',
                     '-a', ${images[3]},
                     '-t', ${templates[3]},
                     '-c', ${clusters[3]},
                     '-o', "${outputPrefix}_",
                     '-f', '0x2',
                     '-r', 1,
                     '-r', 3,
                     '-s', 2,
                     '-b', $numberOfLabels,
                     '-p', "${outputPrefix}_RF_POSTERIORS%d.nii.gz"
                     );

  print FILE "\n@args\n";

  ##
  #
  # Refine results use morphological operations
  #
  ##


  my @rfPosteriors = ();
  for( my $l = 1; $l <= $numberOfLabels; $l++ )
    {
    push( @rfPosteriors, "${outputPrefix}_RF_POSTERIORS${l}.nii.gz" );
    }

  my $necrosisLabel = 1 + 3;
  my $edemaLabel = 2 + 3;
  my $nonEnhancingLabel = 3 + 3;
  my $enhancingLabel = 4 + 3;

  if( $subjectID =~ m/Sim/ )
    {
    $necrosisLabel = 2 + 3;
    $edemaLabel = 1 + 3;
    }

  my $mrfLabels = "${outputPrefix}_RF_LABELS.nii.gz";
  my $mrfCompleteTumor = "${outputPrefix}_RF_LABELS_COMPLETE_TUMOR.nii.gz";
  my $mrfTumorCore = "${outputPrefix}_RF_LABELS_TUMOR_CORE.nii.gz";
  my $mrfEnhancingTumor = "${outputPrefix}_RF_LABELS_ENHANCING_TUMOR.nii.gz";

  my $refinedCompleteTumor = "${outputPrefix}_REFINE_COMPLETE_TUMOR.nii.gz";
  my $refinedTumorCore = "${outputPrefix}_REFINE_TUMOR_CORE.nii.gz";
  my $refinedEnhancingTumor = "${outputPrefix}_REFINE_ENHANCING_TUMOR.nii.gz";
  my $refinedLabels = "${outputPrefix}_REFINE_RF_LABELS.nii.gz";

  ## Remove false positives using erosion and connected components.
  ## Also fill holes

  my $erodedTumor = "${outputPrefix}_REFINE_DILATED_COMPLETE_TUMOR.nii.gz";

  my $maskEroded = $warpedMask;
  $maskEroded =~ s/\.nii\.gz$/Eroded\.nii\.gz/;

  print FILE "${UTILPATH}BinaryMorphology 3 $mask $maskEroded 1  1 1 1\n\n";
  print FILE "${UTILPATH}MultipleOperateImages 3 seg $mrfLabels none @rfPosteriors\n\n";
  print FILE "${ANTSPATH}ThresholdImage 3 $mrfLabels $refinedCompleteTumor 4 7 1 0\n\n";
  print FILE "${UTILPATH}BinaryMorphology 3 $refinedCompleteTumor $erodedTumor 1 3 1 1\n\n";
  print FILE "${UTILPATH}GetConnectedComponents 3 $erodedTumor $erodedTumor 0 0.1\n\n";
  print FILE "${ANTSPATH}ThresholdImage 3 $erodedTumor $erodedTumor 0 0 0 1\n\n";
  print FILE "${UTILPATH}FastMarching 3 $refinedCompleteTumor $refinedCompleteTumor $erodedTumor 10000000 0\n\n";
  print FILE "${ANTSPATH}ThresholdImage 3 $refinedCompleteTumor $refinedCompleteTumor -1000 10000000 1 0\n\n";
  print FILE "${UTILPATH}BinaryMorphology 3 $refinedCompleteTumor $refinedCompleteTumor 5\n\n";
  print FILE "${UTILPATH}BinaryOperateImages 3 $refinedCompleteTumor x $mrfLabels $refinedLabels\n\n";

  print FILE "rm $erodedTumor\n\n\n\n";

  ## We replace edema inside the tumor core with $necrosisLabel

  my $tmp1 = "${outputPrefix}_REFINE_TMP1.nii.gz";
  my $tmp2 = "${outputPrefix}_REFINE_TMP2.nii.gz";
  my $refinedTumorCoreFilled = "${outputPrefix}_REFINE_TUMOR_CORE_FILLED.nii.gz";

  print FILE "${UTILPATH}UnaryOperateImage 3 $refinedLabels r 0 $refinedTumorCore $edemaLabel 0\n\n";
  print FILE "${UTILPATH}UnaryOperateImage 3 $refinedTumorCore t 0 $refinedTumorCore 1 3 0\n\n";
  print FILE "${ANTSPATH}ThresholdImage 3 $refinedTumorCore $refinedTumorCore 0 0 0 1\n\n";

  # need to take care of connected components for tumor core (should only have one component)

  print FILE "${UTILPATH}GetConnectedComponents 3 $refinedTumorCore $tmp1 0 0.1\n\n";
  print FILE "${ANTSPATH}ThresholdImage 3 $refinedTumorCore $refinedTumorCore 0 0 0 1\n\n";
  print FILE "${ANTSPATH}ThresholdImage 3 $tmp1 $tmp1 0 0 0 1\n\n";
  print FILE "${UTILPATH}BinaryOperateImages 3 $refinedTumorCore - $tmp1 $tmp2\n\n";
  print FILE "cp $tmp1 $refinedTumorCore\n\n";
  print FILE "${ANTSPATH}ThresholdImage 3 $tmp2 $tmp1 0 0 1 0\n\n";
  print FILE "${UTILPATH}BinaryOperateImages 3 $tmp1 x $refinedLabels $refinedLabels\n\n";
  print FILE "${UTILPATH}UnaryOperateImage 3 $tmp2 x $edemaLabel $tmp2\n\n";
  print FILE "${UTILPATH}BinaryOperateImages 3 $refinedLabels max $tmp2 $refinedLabels\n\n";

   ##
  print FILE "${UTILPATH}BinaryMorphology 3 $refinedTumorCore $refinedTumorCoreFilled 6 2\n\n";
  print FILE "${UTILPATH}BinaryMorphology 3 $refinedTumorCoreFilled $refinedTumorCoreFilled 5\n\n";

  print FILE "${UTILPATH}BinaryOperateImages 3 $refinedTumorCoreFilled - $refinedTumorCore $tmp1\n\n";
  print FILE "cp $refinedTumorCoreFilled $refinedTumorCore\n\n";

  print FILE "${UTILPATH}UnaryOperateImage 3 $tmp1 x $necrosisLabel $tmp1\n\n";
  print FILE "${UTILPATH}BinaryOperateImages 3 $refinedLabels replace $tmp1 $refinedLabels\n\n";

  print FILE "rm $tmp1\n";
  print FILE "rm $tmp2\n";
  print FILE "rm $refinedTumorCoreFilled\n\n\n\n";

  ## Create different regions

  print FILE "${ANTSPATH}ThresholdImage 3 $refinedLabels $refinedCompleteTumor $necrosisLabel $enhancingLabel 1 0\n\n";
  if( $subjectID !~ m/Sim/ )
    {
    print FILE "${ANTSPATH}ThresholdImage 3 $refinedLabels $refinedEnhancingTumor $enhancingLabel $enhancingLabel 1 0\n\n";
    }

  print FILE "${UTILPATH}BinaryOperateImages 3 $maskEroded x $refinedLabels $refinedLabels\n\n";
  print FILE "${UTILPATH}BinaryOperateImages 3 $maskEroded x $refinedTumorCore $refinedTumorCore\n\n";
  print FILE "${UTILPATH}BinaryOperateImages 3 $maskEroded x $refinedEnhancingTumor $refinedEnhancingTumor\n\n";
  print FILE "${UTILPATH}BinaryOperateImages 3 $maskEroded x $refinedCompleteTumor $refinedCompleteTumor\n\n";

  print FILE "rm $maskEroded\n\n";

  close( FILE );

#   if( ! -e "${outputPrefix}_NORMALIZED_DISTANCE.nii.gz" )
#     {
    print "** apply model ${subjectID}\n";
    my @qargs = ( 'qsub',
                  '-N', $name,
                  '-v', "ANTSPATH=$ANTSPATH",
                  '-v', "UTILPATH=$UTILPATH",
                  '-q', 'nopreempt',
                  '-l', 'mem=12gb',
                  '-l', 'nodes=1:ppn=4',
                  '-l', 'walltime=10:00:00',
                  $commandFile );
    system( @qargs ) == 0 || die "qsub\n";
#     }
#   else
#     {
#     print " feature images ${filename}\n";
#     }
  }


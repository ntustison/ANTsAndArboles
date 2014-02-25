
# for(( j=1; j < 10; j++ ))
#   {
#   echo $j
#   ConvertScalarImageToRGB 3 RefinedLabelsChallenge/BRATS_HG030${j}_REFINE_RF_LABELS.nii.gz RefinedLabelsChallenge/BRATS_HG030${j}_REFINE_RF_LABELS.mha none custom ~/Pkg/ANTs/Examples/CustomColormaps/itkSnap.txt
#   ThresholdImage 3 RefinedLabelsChallenge/BRATS_HG030${j}_REFINE_RF_LABELS.nii.gz RefinedLabelsChallenge/BRATS_HG030${j}_REFINE_RF_LABELS_MASK.nii.gz 0 0 0 1
#   }
# ConvertScalarImageToRGB 3 RefinedLabelsChallenge/BRATS_HG0310_REFINE_RF_LABELS.nii.gz RefinedLabelsChallenge/BRATS_HG0310_REFINE_RF_LABELS.mha none custom ~/Pkg/ANTs/Examples/CustomColormaps/itkSnap.txt
# ThresholdImage 3 RefinedLabelsChallenge/BRATS_HG0310_REFINE_RF_LABELS.nii.gz RefinedLabelsChallenge/BRATS_HG0310_REFINE_RF_LABELS_MASK.nii.gz 0 0 0 1

GEOM='-1x6'

CreateTiledMosaic -i NiftiChallenge/BRATS_HG0301/BRATS_HG0301_FLAIR.nii.gz -r RefinedLabelsChallenge/BRATS_HG0301_REFINE_RF_LABELS.mha -a 1.0 -o RefinedLabelsChallenge/BRATS_HG0301_REFINE_RF_LABELS.png -t $GEOM -d 2 -s [7,40,78] -x RefinedLabelsChallenge/BRATS_HG0301_REFINE_RF_LABELS_MASK.nii.gz
CreateTiledMosaic -i NiftiChallenge/BRATS_HG0302/BRATS_HG0302_FLAIR.nii.gz -r RefinedLabelsChallenge/BRATS_HG0302_REFINE_RF_LABELS.mha -a 1.0 -o RefinedLabelsChallenge/BRATS_HG0302_REFINE_RF_LABELS.png -t $GEOM -d 2 -s [7,60,98] -x RefinedLabelsChallenge/BRATS_HG0302_REFINE_RF_LABELS_MASK.nii.gz
CreateTiledMosaic -i NiftiChallenge/BRATS_HG0303/BRATS_HG0303_FLAIR.nii.gz -r RefinedLabelsChallenge/BRATS_HG0303_REFINE_RF_LABELS.mha -a 1.0 -o RefinedLabelsChallenge/BRATS_HG0303_REFINE_RF_LABELS.png -t $GEOM -d 2 -s [7,60,98] -x RefinedLabelsChallenge/BRATS_HG0303_REFINE_RF_LABELS_MASK.nii.gz
CreateTiledMosaic -i NiftiChallenge/BRATS_HG0304/BRATS_HG0304_FLAIR.nii.gz -r RefinedLabelsChallenge/BRATS_HG0304_REFINE_RF_LABELS.mha -a 1.0 -o RefinedLabelsChallenge/BRATS_HG0304_REFINE_RF_LABELS.png -t $GEOM -d 2 -s [7,60,98] -x RefinedLabelsChallenge/BRATS_HG0304_REFINE_RF_LABELS_MASK.nii.gz
CreateTiledMosaic -i NiftiChallenge/BRATS_HG0305/BRATS_HG0305_FLAIR.nii.gz -r RefinedLabelsChallenge/BRATS_HG0305_REFINE_RF_LABELS.mha -a 1.0 -o RefinedLabelsChallenge/BRATS_HG0305_REFINE_RF_LABELS.png -t $GEOM -d 2 -s [7,75,113] -x RefinedLabelsChallenge/BRATS_HG0305_REFINE_RF_LABELS_MASK.nii.gz
CreateTiledMosaic -i NiftiChallenge/BRATS_HG0306/BRATS_HG0306_FLAIR.nii.gz -r RefinedLabelsChallenge/BRATS_HG0306_REFINE_RF_LABELS.mha -a 1.0 -o RefinedLabelsChallenge/BRATS_HG0306_REFINE_RF_LABELS.png -t $GEOM -d 2 -s [7,70,108] -x RefinedLabelsChallenge/BRATS_HG0306_REFINE_RF_LABELS_MASK.nii.gz
CreateTiledMosaic -i NiftiChallenge/BRATS_HG0307/BRATS_HG0307_FLAIR.nii.gz -r RefinedLabelsChallenge/BRATS_HG0307_REFINE_RF_LABELS.mha -a 1.0 -o RefinedLabelsChallenge/BRATS_HG0307_REFINE_RF_LABELS.png -t $GEOM -d 2 -s [7,70,108] -x RefinedLabelsChallenge/BRATS_HG0307_REFINE_RF_LABELS_MASK.nii.gz
CreateTiledMosaic -i NiftiChallenge/BRATS_HG0308/BRATS_HG0308_FLAIR.nii.gz -r RefinedLabelsChallenge/BRATS_HG0308_REFINE_RF_LABELS.mha -a 1.0 -o RefinedLabelsChallenge/BRATS_HG0308_REFINE_RF_LABELS.png -t $GEOM -d 2 -s [7,40,78] -x RefinedLabelsChallenge/BRATS_HG0308_REFINE_RF_LABELS_MASK.nii.gz
CreateTiledMosaic -i NiftiChallenge/BRATS_HG0309/BRATS_HG0309_FLAIR.nii.gz -r RefinedLabelsChallenge/BRATS_HG0309_REFINE_RF_LABELS.mha -a 1.0 -o RefinedLabelsChallenge/BRATS_HG0309_REFINE_RF_LABELS.png -t $GEOM -d 2 -s [7,40,78] -x RefinedLabelsChallenge/BRATS_HG0309_REFINE_RF_LABELS_MASK.nii.gz
CreateTiledMosaic -i NiftiChallenge/BRATS_HG0310/BRATS_HG0310_FLAIR.nii.gz -r RefinedLabelsChallenge/BRATS_HG0310_REFINE_RF_LABELS.mha -a 1.0 -o RefinedLabelsChallenge/BRATS_HG0310_REFINE_RF_LABELS.png -t $GEOM -d 2 -s [7,60,98] -x RefinedLabelsChallenge/BRATS_HG0310_REFINE_RF_LABELS_MASK.nii.gz

CreateTiledMosaic -i NiftiChallenge/BRATS_HG0301/BRATS_HG0301_FLAIR.nii.gz -o RefinedLabelsChallenge/BRATS_HG0301_FLAIR.nii.gz -t $GEOM -d 2 -s [7,40,78]
FlipImage 2 RefinedLabelsChallenge/BRATS_HG0301_FLAIR.nii.gz tmp.nii.gz 0x1
ConvertImage 2 tmp.nii.gz RefinedLabelsChallenge/BRATS_HG0301_FLAIR.png 1

CreateTiledMosaic -i NiftiChallenge/BRATS_HG0302/BRATS_HG0302_FLAIR.nii.gz -o RefinedLabelsChallenge/BRATS_HG0302_FLAIR.nii.gz -t $GEOM -d 2 -s [7,60,98]
FlipImage 2 RefinedLabelsChallenge/BRATS_HG0302_FLAIR.nii.gz tmp.nii.gz 0x1
ConvertImage 2 tmp.nii.gz RefinedLabelsChallenge/BRATS_HG0302_FLAIR.png 1

CreateTiledMosaic -i NiftiChallenge/BRATS_HG0303/BRATS_HG0303_FLAIR.nii.gz -o RefinedLabelsChallenge/BRATS_HG0303_FLAIR.nii.gz -t $GEOM -d 2 -s [7,60,98]
FlipImage 2 RefinedLabelsChallenge/BRATS_HG0303_FLAIR.nii.gz tmp.nii.gz 0x1
ConvertImage 2 tmp.nii.gz RefinedLabelsChallenge/BRATS_HG0303_FLAIR.png 1

CreateTiledMosaic -i NiftiChallenge/BRATS_HG0304/BRATS_HG0304_FLAIR.nii.gz -o RefinedLabelsChallenge/BRATS_HG0304_FLAIR.nii.gz -t $GEOM -d 2 -s [7,60,98]
FlipImage 2 RefinedLabelsChallenge/BRATS_HG0304_FLAIR.nii.gz tmp.nii.gz 0x1
ConvertImage 2 tmp.nii.gz RefinedLabelsChallenge/BRATS_HG0304_FLAIR.png 1

CreateTiledMosaic -i NiftiChallenge/BRATS_HG0305/BRATS_HG0305_FLAIR.nii.gz -o RefinedLabelsChallenge/BRATS_HG0305_FLAIR.nii.gz -t $GEOM -d 2 -s [7,75,113]
FlipImage 2 RefinedLabelsChallenge/BRATS_HG0305_FLAIR.nii.gz tmp.nii.gz 0x1
ConvertImage 2 tmp.nii.gz RefinedLabelsChallenge/BRATS_HG0305_FLAIR.png 1

CreateTiledMosaic -i NiftiChallenge/BRATS_HG0306/BRATS_HG0306_FLAIR.nii.gz -o RefinedLabelsChallenge/BRATS_HG0306_FLAIR.nii.gz -t $GEOM -d 2 -s [7,70,108]
FlipImage 2 RefinedLabelsChallenge/BRATS_HG0306_FLAIR.nii.gz tmp.nii.gz 0x1
ConvertImage 2 tmp.nii.gz RefinedLabelsChallenge/BRATS_HG0306_FLAIR.png 1

CreateTiledMosaic -i NiftiChallenge/BRATS_HG0307/BRATS_HG0307_FLAIR.nii.gz -o RefinedLabelsChallenge/BRATS_HG0307_FLAIR.nii.gz -t $GEOM -d 2 -s [7,70,108]
FlipImage 2 RefinedLabelsChallenge/BRATS_HG0307_FLAIR.nii.gz tmp.nii.gz 0x1
ConvertImage 2 tmp.nii.gz RefinedLabelsChallenge/BRATS_HG0307_FLAIR.png 1

CreateTiledMosaic -i NiftiChallenge/BRATS_HG0308/BRATS_HG0308_FLAIR.nii.gz -o RefinedLabelsChallenge/BRATS_HG0308_FLAIR.nii.gz -t $GEOM -d 2 -s [7,40,78]
FlipImage 2 RefinedLabelsChallenge/BRATS_HG0308_FLAIR.nii.gz tmp.nii.gz 0x1
ConvertImage 2 tmp.nii.gz RefinedLabelsChallenge/BRATS_HG0308_FLAIR.png 1

CreateTiledMosaic -i NiftiChallenge/BRATS_HG0309/BRATS_HG0309_FLAIR.nii.gz -o RefinedLabelsChallenge/BRATS_HG0309_FLAIR.nii.gz -t $GEOM -d 2 -s [7,40,78]
FlipImage 2 RefinedLabelsChallenge/BRATS_HG0309_FLAIR.nii.gz tmp.nii.gz 0x1
ConvertImage 2 tmp.nii.gz RefinedLabelsChallenge/BRATS_HG0309_FLAIR.png 1

CreateTiledMosaic -i NiftiChallenge/BRATS_HG0310/BRATS_HG0310_FLAIR.nii.gz -o RefinedLabelsChallenge/BRATS_HG0310_FLAIR.nii.gz -t $GEOM -d 2 -s [7,60,98]
FlipImage 2 RefinedLabelsChallenge/BRATS_HG0310_FLAIR.nii.gz tmp.nii.gz 0x1
ConvertImage 2 tmp.nii.gz RefinedLabelsChallenge/BRATS_HG0310_FLAIR.png 1

rm -f tmp.nii.gz



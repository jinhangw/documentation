%Algorithm: Changing color brightness of images
%Designer: Krasanakis Manios
%Date: January 21, 2010
%
%DESCRIPTION
%This algorithm changes all values of red green an blue in 3-depthed
%images. Therefore, one can change the brightness of the image or the
%balance between those three colors.
%
%CALL
%a_table=brightness(input,brightness);
%
%INPUTS
%input            (image table)         : image table to change colors
%brightness       (3 integer vector)    : color changes
%
%RETURNS (OUTPUTS)
%output          (image table)          : image with changes colors
%
%SPECIAL CASES
%brightness=[Bri, Bri, Bri] : brighten the image, equaly to the Bri value
%                             if Bri is negative, the image is darkened
%brightness=[0, -255, -255] : get the red tones of the image
%brightness=[-255, 0, -255] : get the green tones of the image
%brightness=[-255, -255, 0] : get the blue tone of the image
%
%WARNINGS
%All color brightnesses are kept within the range 0,255. Therefore, if you
%change a pixel color outside this range, its value is pracically lost.
%This algorithm can be quite slow for big images, dellaying their
%processing for even 2-3 seconds. Therefore, it is recommended not to be
%put in a repeatitive loop.

function output=brightness(input,brightness)
inputSize=size(input);

if(numel(inputSize)==3)&&(numel(brightness)==3)
    output=input;
    for i=1:inputSize(1)
    for j=1:inputSize(2)
        for k=1:3
            output(i,j,k)=input(i,j,k)+brightness(k);
            if(output(i,j,k)>255)
                output(i,j,k)=255;
            end
            if(output(i,j,k)<0)
                output(i,j,k)=0;
            end
        end
    end
    end
else
    error('RGB color image and brightness input required');%$ok
end

end

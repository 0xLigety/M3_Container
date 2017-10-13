// Include files to use the PYLON API.
#include <pylon/PylonIncludes.h>
#include <pylon/gige/PylonGigEIncludes.h>
#include <pylon/gige/BaslerGigECamera.h>
#include <pylon/gige/BaslerGigEInstantCamera.h>
#include <pylon/ImagePersistence.h>
#include <string>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/imgcodecs/imgcodecs.hpp>
#include "logging.h"
#include "read_config.h"
#include "error_defines.h"
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <sstream>

#define MRX
#define CONFIG_FILE_PATH "/usr/application/configuration.config"

#define APP_NAME "pylon"

#define SPLIT_LINE "\n############################################"

#define BUFFER_SIZE     200


// Namespace for using pylon objects.
using namespace Pylon;
using namespace GenApi;
// Namespace for using opencv objects.
using namespace cv;

// Namespace for using cout.
using namespace std;


int main(int argc, char *argv[])
{
    // The exit code of the sample application.
    int exitCode = 0;

    // Before using any pylon methods, the pylon runtime must be initialized.
    Pylon::PylonAutoInitTerm autoInitTerm;

    try
    {

        int exitCode = 0;
        string imageDriver = argv[2];
        
        // This smart pointer will receive the grab result data.
        CGrabResultPtr ptrGrabResult;
        CImageFormatConverter formatConverter;//me
        formatConverter.OutputPixelFormat = PixelType_BGR8packed;//me
        CPylonImage pylonImage;
        CTlFactory &TlFactory = CTlFactory::GetInstance();
        ITransportLayer* pTl = TlFactory.CreateTl( CBaslerGigECamera::DeviceClass() );


        // Create an OpenCV image
	    Mat openCvImage;

        CBaslerGigEDeviceInfo di;
        di.SetIpAddress(argv[1]);
        IPylonDevice* pDevice = pTl->CreateDevice(di);
        CBaslerGigEInstantCamera Camera(pDevice);

        Camera.MaxNumBuffer = 2;

        // Print the model name of the camera.
       
        printf("Using Device %s ",Camera.GetDeviceInfo().GetModelName());
       
 
        log_entry(APP_NAME, "Start grabbing image");
        printf("Start grabbing image");
        
        
        
        if(Camera.GrabOne(5000,ptrGrabResult,TimeoutHandling_ThrowException)){
      
            log_entry(APP_NAME, "Grab successful");
            printf("Grab successful");
            
            formatConverter.Convert(pylonImage, ptrGrabResult);
            if(imageDriver=="pylon"){
                log_entry(APP_NAME, "Using pylon imagepersistence");
                printf("Using pylon imagepersistence");
                CImagePersistence::Save(ImageFileFormat_Png, "GrabbedImage.png", pylonImage);

            }else{
                log_entry(APP_NAME, "Using opencv imwrite");
                printf("Using opencv imwrite");
                openCvImage= cv::Mat(ptrGrabResult->GetHeight(), ptrGrabResult->GetWidth(), CV_8UC3, (uint8_t *) pylonImage.GetBuffer());
                imwrite("GrabbedImage.png", openCvImage); 
            }
          
            
            log_entry(APP_NAME, "Image saved");
            printf("Image saved");
            
            
        }
        else{
            log_entry(APP_NAME, "Error: Grabbing image failed");
            printf("Error: %c %s ",ptrGrabResult->GetErrorCode(),ptrGrabResult->GetErrorDescription());
            exitCode = 1;
        }
    }
    catch (const GenericException &e)
    {
        log_entry(APP_NAME, "Could not grab an image",e.GetDescription());
        printf( "Could not grab an image: %s ",e.GetDescription());
        exitCode = 1;
    }
   
    return exitCode;
}
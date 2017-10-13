// Include files to use the PYLON API.
#include <pylon/PylonIncludes.h>
#include <pylon/gige/PylonGigEIncludes.h>
#include <pylon/gige/BaslerGigECamera.h>
#include <pylon/gige/BaslerGigEInstantCamera.h>
#include <pylon/ImagePersistence.h>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/imgcodecs/imgcodecs.hpp>





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
        cout << "Using device " << Camera.GetDeviceInfo().GetModelName() << endl;
         
        cout << "Start grabbing image" << endl;
        
        if(Camera.GrabOne(5000,ptrGrabResult,TimeoutHandling_ThrowException)){
            cout << "Grab successful" << endl;
            
            formatConverter.Convert(pylonImage, ptrGrabResult);
      
            openCvImage= cv::Mat(ptrGrabResult->GetHeight(), ptrGrabResult->GetWidth(), CV_8UC3, (uint8_t *) pylonImage.GetBuffer());
            imwrite("GrabbedImage.jpg", openCvImage); 
            
          
            
            cout << "Image saved" << endl;
            
            
        }
        else{
             
            cout << "Error: " << ptrGrabResult->GetErrorCode() << " " << ptrGrabResult->GetErrorDescription() << endl;
            exitCode = 1;
        }
    }
    catch (const GenericException &e)
    {
        
        cerr << "Could not grab an image: " << endl
             << e.GetDescription() << endl;
        exitCode = 1;
    }
   
    return exitCode;
}
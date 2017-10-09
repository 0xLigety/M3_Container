// Include files to use the PYLON API.
#include <pylon/PylonIncludes.h>
#include <pylon/gige/PylonGigEIncludes.h>
#include <pylon/gige/BaslerGigECamera.h>
#include <pylon/gige/BaslerGigEInstantCamera.h>

// Namespace for using pylon objects.
using namespace Pylon;
using namespace GenApi;

// Namespace for using cout.
using namespace std;

int main(int argc, char *argv[])
{
    // The exit code of the sample application.
    int exitCode = 0;

    // Before using any pylon methods, the pylon runtime must be initialized.
    PylonInitialize();

    try
    {

        // Define some constants.
        const uint32_t cWidth = 640;
        const uint32_t cHeight = 480;

        // This smart pointer will receive the grab result data.
        CGrabResultPtr ptrGrabResult;
        CTlFactory &TlFactory = CTlFactory::GetInstance();
        ITransportLayer* pTl = TlFactory.CreateTl( CBaslerGigECamera::DeviceClass() );

        //DeviceInfoList_t lstDevices;
        //pTl->EnumerateDevices( lstDevices );
        //if ( lstDevices.empty() ) {
        //    cerr <<  "No devices found" << endl;
        //    exit(1);
       //}
        //IPylonDevice* pDevice = pTl->CreateDevice( lstDevices[0] );
        CBaslerGigEDeviceInfo di;
        di.SetIpAddress(argv[1]);
        //IPylonDevice *device = TlFactory.CreateDevice(di);
        IPylonDevice* pDevice = pTl->CreateDevice(di);
        CBaslerGigEInstantCamera Camera(pDevice);

         // Print the model name of the camera.
         cout << "Using device " << Camera.GetDeviceInfo().GetModelName() << endl;
         
        // Open the camera.
        Camera.Open();

        Camera.StartGrabbing(1);

        while(Camera.IsGrabbing())
        {
            // Wait for an image and then retrieve it. A timeout of 5000 ms is used.
            Camera.RetrieveResult(5000, ptrGrabResult, TimeoutHandling_ThrowException);

            // Image grabbed successfully?
            if (ptrGrabResult->GrabSucceeded())
            {
                // Access the image data.
                cout << "SizeX: " << ptrGrabResult->GetWidth() << endl;
                cout << "SizeY: " << ptrGrabResult->GetHeight() << endl;
                const uint8_t *pImageBuffer = (uint8_t *) ptrGrabResult->GetBuffer();
                cout << "Gray value of first pixel: " << (uint32_t) pImageBuffer[0] << endl << endl;

            CImagePersistence::Save(ImageFileFormat_Png, "GrabbedImage.png", ptrGrabResult);
            break;
            }
            else
            {
                cout << "Error: " << ptrGrabResult->GetErrorCode() << " " << ptrGrabResult->GetErrorDescription() << endl;

                
            }
        }
        Camera.Close();   
        
    }
    catch (const GenericException &e)
    {
        PylonTerminate(); 
        cerr << "Could not grab an image: " << endl
             << e.GetDescription() << endl;
    }

    PylonTerminate(); 
}
// Include files to use the PYLON API.
#include <pylon/PylonIncludes.h>
#include <pylon/gige/PylonGigEIncludes.h>

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
        CBaslerGigEDeviceInfo di;
        di.SetIpAddress(argv[1]);
        IPylonDevice *device = TlFactory.CreateDevice(di);
        CBaslerGigEInstantCamera Camera(device);

        if (Camera.GrabOne(1000, ptrGrabResult))
        {
            // The pylon grab result smart pointer classes provide a cast operator to the IImage
            // interface. This makes it possible to pass a grab result directly to the
            // function that saves an image to disk.
            CImagePersistence::Save(ImageFileFormat_Png, "GrabbedImage.png", ptrGrabResult);
        }
    }
    catch (const GenericException &e)
    {

        cerr << "Could not grab an image: " << endl
             << e.GetDescription() << endl;
    }
}
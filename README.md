#BNToolkit pod repo

Any classes which can potentially be useful across projects should be added and improved upon over time.

##BNUtil

A collection of loosely organised helper functions and macros.

##BNFacebookManager

Provides a simple, abstracted interface for managing Facebook authentication and retrieving basic user information. Since the interface between the Facebook SDK is abstracted, the app itself ideally shouldn't be interacting directly with the SDK itself which has historically been an issue as the API changes. The class should be incrementally extended as various projects make use of extra Facebook API functionality.

##BNDeviceUtil

Provides helper methods and macros to identify the screen metrics of the device, such as the logical screen size, scale etc. This should be built upon as new devices with varying metrics are released.

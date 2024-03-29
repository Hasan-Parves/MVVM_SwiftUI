# MVVM code base with SwiftUI
A Demo to start MVVM Code base to start an iOS project.
This app shows a list of transaction data. The data of the transaction list can be fetched from the local directory mock data file or from a test server or from the real production server, so if BE is not ready then UI work can continue by mock data.
There is a forced error every 10 random tries to handle the error as well. 

<p align="center">
 <img src="https://github.com/Hasan-Parves/MVVM_SwiftUI/assets/45826738/50597be0-c7d2-44e6-83aa-b302f102f042" width="208" height="450">
</p>

## Features


- Design Pattern - MVVM
- Dependency Injection
- Modularization of HTTP Client
- Use of Mock data if BE is not ready
- Preprocessor check for using
  - Test Server Data or
  - MockData or
  - Real Server Data
- JSON Parsing
- SortComparator
- Network(Internet) change detection
- Localization (English and German)
- ViewModel Unit Test
- UI Test

  
## Sources
### Views
* Landing page -> TransactionListView
* Side Menu pages -> SideMenuView
  * FeedView
  * OnlineShoppingView
  * SettingsView

### ViewModel
* TransactionListViewModel
    * ObservableObject to help SwiftUI TransactionListView 
    * Used to fetch transactions
    * Toggle show error alert published variable 

### Model
* Transaction
  * Data Model
  * Init with decoder 

### API Service
* TransactionListService
  * Custom API HTTP Client Request call
* TransactionEndpoints
  * Used to modify endpoint param like URL param, authentication data, validator, base path etc.  

### Mock API Service
* MockTransactionListService
  * Used to return local directory mock data
  * Also used to simulate forced error
  * SortComparator by BookingDate

### Helper
* NetworkMonitor
  * Used to check internet connection.  
* NetworkUnavailableView
  * Used to show that the internet is not available. 

## Test
### Unit Test
* WorldOfPAYBACKTests
### API Test Mock Spy
* TransactionListServiceSpy
### UI Test
* WorldOfPAYBACKUITests

## How to use Mock Data 🔧

For using Mock data init TransactionListView with MockTransactionListService

```bash
let useMockData = Bundle.main.object(forInfoDictionaryKey: "USE_MOCK_DATA") as! Bool

if useMockData {
    let transactionListService: TransactionListService = MockTransactionListService(httpClient: HTTPClient())
    TransactionListView(transactionListService: transactionListService).environmentObject(networkMonitor)
}
```
## How to use test Server Data 🔧

Or for using Test Server data init TransactionListView with TransactionListAPIService

```bash
let useTestData = Bundle.main.object(forInfoDictionaryKey: "USE_TEST_DATA") as! Bool

 if useTestData {
/* Extension HTTPEndpoint also has this check for test data server in basePath,
 but we can also call this from here as well. I like to inject dependency in calling.*/
	let transactionListService: TransactionListService = TransactionListAPIService(
					httpClient: HTTPClient(shouldUseTestServer: useTestData)
				)
   TransactionListView(transactionListService: transactionListService).environmentObject(networkMonitor)
}
```
### Set the Test Base path 🔧

```bash
var testBasePath: String {
        "api-test.payback.com/"
    }

  if shouldUseTestServer {
            components?.path = "/\(endpoint.testBasePath)\(endpoint.path)"
        } else {
            components?.path = "/\(endpoint.basePath)\(endpoint.path)"
}
```

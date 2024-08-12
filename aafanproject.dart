import 'dart:io';

void main() {
  User user = User(9717);

  BankAccount userAccount = BankAccount(3, 7500);
  BankAccount sendAccount = BankAccount(2033, 5000);

  ATM atm = ATM(user);
  atm.checkPin();

  if (atm.isAuthenticated) {
    atm.selectAccountType();
    atm.performOperation(userAccount, sendAccount);
  } else {
    print("Authentication failed. Exiting...");
  }
}

class User {
  int pin;

  User(this.pin);
}

class ATM extends BankAccount {
  User currentUser;
  bool isAuthenticated = false;

  ATM(this.currentUser) : super(0, 500000);

  void checkPin() {
    print('Enter your Pin:');
    int enteredPin = int.parse(stdin.readLineSync()!);

    if (enteredPin == currentUser.pin) {
      isAuthenticated = true;
      print("Authentication successful.");
    } else {
      print("Invalid PIN.");
    }
  }

  @override
  void selectAccountType() {
    print("Please select your account type:");
    print("1: Current");
    print("2: Savings");
    String? choice = stdin.readLineSync();

    if (choice == "1") {
      selectedAccount = "Current";
    } else if (choice == "2") {
      selectedAccount = "Savings";
    } else {
      print("Invalid choice. Defaulting to Savings account.");
      selectedAccount = "Savings";
    }
  }

  void performOperation(BankAccount userAccount, [BankAccount? sendAccount]) {
    print("Select operation:");
    print("1: Withdraw");
    print("2: Deposit");
    print("3: Balance Inquiry");
    print("4: Transfer");
    String? operationChoice = stdin.readLineSync();

    switch (operationChoice) {
      case "1":
        withdraw(userAccount);
        break;
      case "2":
        deposit(userAccount);
        break;
      case "3":
        balanceInquiry(userAccount);
        break;
      case "4":
        if (sendAccount != null) {
          transfer(userAccount, sendAccount);
        } else {
          print("No account provided for transfer.");
        }
        break;
      default:
        print("Invalid operation choice.");
        break;
    }
  }

  void withdraw(BankAccount userAccount) {
    print("Enter amount to withdraw:");
    int amount = int.parse(stdin.readLineSync()!);

    if (userAccount.selectedAccount == 'Savings' ||
        userAccount.selectedAccount == 'Current') {
      if (userAccount.accountBalance >= amount) {
        userAccount.accountBalance -= amount;
        print(
            "Withdraw ${amount} from ${userAccount.selectedAccount} account.");
        print("New balance: ${userAccount.accountBalance}");
      } else {
        print("Insufficient balance in account");
      }
    }
  }

  void deposit(BankAccount userAccount) {
    print("Enter amount to deposit:");
    int amount = int.parse(stdin.readLineSync()!);

    if (userAccount.selectedAccount == 'Savings' ||
        userAccount.selectedAccount == 'Current') {
      userAccount.accountBalance += amount;
      print("Deposited ${amount} to ${userAccount.selectedAccount} account.");
      print("New balance: ${userAccount.accountBalance}");
    }
  }

  void balanceInquiry(BankAccount userAccount) {
    print(
        "${userAccount.selectedAccount} account balance: ${userAccount.accountBalance}");
  }

  void transfer(BankAccount userAccount, BankAccount sendAccount) {
    print("Enter amount to transfer:");
    int amount = int.parse(stdin.readLineSync()!);

    if (userAccount.accountBalance >= amount) {
      userAccount.accountBalance -= amount;
      sendAccount.accountBalance += amount;
      print(
          "Transferred ${amount} from account ${userAccount.accountNumber} to account ${sendAccount.accountNumber}.");
      print("New balance: ${userAccount.accountBalance}");
    } else {
      print("Insufficient balance for transfer.");
    }
  }
}

class BankAccount {
  int accountNumber;
  int accountBalance;
  String? selectedAccount;

  BankAccount(this.accountNumber, this.accountBalance);

  void selectAccountType() {}
}

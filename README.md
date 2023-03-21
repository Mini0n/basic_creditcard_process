# basic_creditcard_process

Basic Credit Card Processing simulation [Add, Charge, Credit]

This program simulates the execution of Credit Card operations
- Add: adds a new User with an associated Credit Card (with a credit limit & an initial balance of $0)
- Charge: it adds balance to a previously added User
- Credit: it takes balance from a previously added User

The program reads input instructions from a file or from STDIN.


**Example Input**
```
Given the following input:
Add Tom 4111111111111111 $1000
Add Lisa 5454545454545454 $3000
Add Quincy 1234567890123456 $2000
Charge Tom $500
Charge Tom $800
Charge Lisa $7
Credit Lisa $100
Credit Quincy $200
```

**Expected output**
```
Lisa: $-93
Quincy: error
Tom: $500
```

### Usage
**Processing instructions from a file**
```
ruby basic_card_processor.rb ./spec/fixtures/original_test.txt
```
**Processing instructions from STDIN**
```
ruby basic_card_processor.rb < ./spec/fixtures/original_test.txt
```

### Requirements

- Ruby 2.7.6


### Running the program

This code was developer using Ruby 2.7.6.
To run the program please install it.
My prefered way is through rvm: [Ruby Version Manager](https://rvm.io/)

After that, there are some gems used for development, card number validation & testing.

Please install them by running:
```
bundle install
```

### Testing

Most of the code has been tested with the help of RSpec.
Every operation method, the gears behing the curtains is 100% covered.

To run the tests just call rspec:
```
rspec
```







An overview of your design decisions
- Why you picked the programming language you used
- How to run your code and tests

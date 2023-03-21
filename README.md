# 💳 basic_creditcard_process

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

### 🖥️  Usage
**Processing instructions from a file**
```
ruby basic_card_processor.rb ./spec/fixtures/original_test.txt
```
**Processing instructions from STDIN**
```
ruby basic_card_processor.rb < ./spec/fixtures/original_test.txt
```

### 🧰  Requirements

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

### ⚗️  Testing

Most of the code has RSpec coverage tests.

Every operation method, the gears behing the curtains is 100% covered.

To run the tests just call rspec with the following command:
```
rspec
```

### 💭  About

This code has been developed in Ruby since it's my main programming language.
- web development relevant
- stable, updated & constantly improved
- tons of support from the community
- easy to write & easy to read

However, I believe it could be easily ported to any other language.

I think everything has been nicely abstracted.

**about design...**

My design approach for this code followed three ideas:

1. Stick to the basics: focus & code each operation to do what it needs to.
2. Let the user be the most important one of the models. The user use the operations and not the other way around.
3. Let the code do the work.

So, with that in mind I decided I needed at least three abstractions:
A User, a Card and an instruction Processor.

The Card should handle its validation, limits and operations.
Nothing complex here. Just do what you need to do and nothing else.

The User should have one Card (and just one for this scenerio) and be able to use it. Execute operations in it.

The Processor was the trickier one. Its always fun to handle inputs.
Even if the input has been sanitized beforehand it's always important to withstand what is thrown.

Originaly I was thinking of splitting the instructions and do some "manual" verifications over them before calling the methods that will run them but it was way more efficient to just use regular experessions.

With the regular expressions in place I just needed to asked the users to do what the instruction said.

So I created a UserList. It will hold all the users from the execution. I used a simple Hash for this.
With a Hash I could use the User name as a key (since no repeated User names are allowed) and get it's instance. The UserList model also helped to avoid run operations if the User was invalid (Invalid Card). And print the status; the Users' current balances.

So, I had a Processor which will have a UserList.
Then, it will check & run an instruction (if its a valid one) to create a User, or ask it to do an operation. Now the program is handling itself. I just pass instructions and it decides if it runs or it does not.

Everything is working. We just need the final touches. To run everything from the console.

Read information from a file or STDIN and pass it over to a Processor instance. The Processor will know what to do. Just add some screens and an Exception handler to keep everything at bay in case something weird is passed to the program, like a file that does not exist.

So, everything worked and seems to hold together.
Each abstraction does what it is intended to do and allows to be built upon.

Let the code do the work.




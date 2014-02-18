# ErrataSlip [![Build Status](https://travis-ci.org/artemf/errata_slip.png?branch=master)](https://travis-ci.org/artemf/errata_slip)

Apply corrections from yaml file to array of records. Useful in scraping/parsing when one needs to apply errata to the scraped data.

#### Use case 1 - Easily apply fixes to scraped data

**errata.yaml:**

```YAML
- city:  "LasVegas"
  ~city:   "Las Vegas"
- city:  "LosAngeles"
  ~city:   "Los Angeles"
```

**apply_errata.rb:**

```ruby
records = [ { city: 'LasVegas', population: '596424' },
            { city: 'LosAngeles', population: '3857799' } ]
ErrataSlip::load_file('errata.yaml').correct!(records)
p records
=> [ { city: 'Las Vegas', population: '596424' },
     { city: 'Los Angeles', population: '3857799' } ]
```

#### Use case 2 - Add additional metadata to your data

**errata.yaml:**

```YAML
- city:    "Los Angeles"
  country: "USA"
  ~state:    "California"
- city:    "Los Angeles"
  country: "USA"
  ~state:    "Nevada"
```

**apply_errata.rb:**

```ruby
records = [ { city: 'Las Vegas',   country: 'USA' },
            { city: 'Los Angeles', country: 'USA' } ]
ErrataSlip::load_file('errata.yaml').correct!(records)
p records
=> [ { city: 'Las Vegas',   country: 'USA', state: 'Nevada' },
     { city: 'Los Angeles', country: 'USA', state: 'California' } ]
```

## Installation

Add this line to your application's Gemfile:

    gem 'errata_slip'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install errata_slip

## Usage

You are expected to have array of hashes as an input and corrections are applied to it.

#### Errata file

You create ErrataSlip from yaml file with errata
```ruby
e = ErrataSlip::load_file('errata.yaml')
```

Errata file is array of hashes, which has 'match' fields and 'correct' fields. 'Match' fields are used
to find the record to correct, 'correct' fields are used to apply changes to the record. 'Correct' fields
are prefixed with tilde (~):

```YAML
- fieldname:  "Value of fieldname to find"
  ~fieldname:   "Value of fieldname to replace"
```

For example, if your records have key 'name', errata file might look like this: 

```YAML
- name:  "Name to find"
  ~name:   "Name to replace with"
```

'Correct' fields can introduce new fields to your records:

```YAML
- name:  "Name to find"
  ~name:            "Name to replace with"
  ~applied_errata:  true
```

#### Applying errata to all records

You use correct! method to correct all records in-place

```ruby
scraped_records = [ { :name => 'Adam'}, { :name => 'Eve' } ]
ErrataSlip::load_file('errata.yaml').correct!(scraped_records)
```

#### Applying errata to single record

You use correct_item! method to correct one hash in-place

```ruby
scraped_records = [ { :name => 'Adam'}, { :name => 'Eve' } ]
errata = ErrataSlip::load_file('errata.yaml')
scraped_records.map { |record| errata.correct_item!(record) }
```

#### Works with both symbolic and string hash keys

While errata file is written with string hash keys, correction works on both string-keyed hashed and symbol-keyed hashes.

So it doesn't matter if you have 

```ruby
scraped_records = [ { :name => 'Adam'}, { :name => 'Eve' } ]
```

or

```ruby
scraped_records = [ { 'name' => 'Adam'}, { 'name' => 'Eve' } ]
```

ErrataSlip will autodetect format and apply errata correctly.

## Examples

#### Easily fix missplelings or inaccuracies in scraped data

In this example we change all names from 'Adaam' to 'Adam'

errata.yaml
```YAML
- name:  "Adaam"
  ~name:   "Adam"
```

apply_errata.rb
```ruby
records = [
             { name: 'Adaam' },
             { name: 'Andrew' }
          ]
ErrataSlip::load_file('errata.yaml').correct!(records)
p records
=> [
      { name: 'Adam' },
      { name: 'Andrew' }
   ]
```

#### You can match several fields and correct several fields at the same time

We search for all records with name 'Hillary' and surname 'Clinton' and change them to 'Monika' and 'Lewinsky'
respectively.

errata.yaml
```YAML
- name:    "Hillary"
  surname: "Clinton"
  ~name:     "Monika"
  ~surname:  "Lewinsky"
```

apply_errata.rb
```ruby
records = [
             { name: 'Bill', surname: 'Clinton' },
             { name: 'Hillary', surname: 'Clinton' }
          ]
ErrataSlip::load_file('errata.yaml').correct!(records)
p records
=> [
      { name: 'Bill', surname: 'Clinton' },
      { name: 'Monika', surname: 'Lewinsky' }
   ]
```

#### 'Match' fields and 'correct' fields shouldn't be the same

This example searches all records with name 'Adam' and changes surname to 'Smith' and book to 'The Wealth of Nations'.

errata.yaml
```YAML
- name:    "Adam"
  ~surname:  "Smith"
  ~book:     "The Wealth of Nations"
```

apply_errata.rb
```ruby
records = [
             { name: 'Adam', surname: 'Mansbach', book: 'Go the F**k to Sleep' }
          ]
ErrataSlip::load_file('errata.yaml').correct!(records)
p records
=> [
      { name: 'Adam', surname: 'Smith', book: 'The Wealth of Nations' }
   ]
```

#### We can not only change existing fields, but also add new ones

The syntax is the same.

errata.yaml
```YAML
- name:    "Adam"
  surname: "Smith"
  ~book:     "The Wealth of Nations"
```

apply_errata.rb
```ruby
records = [
             { name: 'Adam', surname: 'Smith' },
             { name: 'Adam', surname: 'Mansbach', book: 'Go the F**k to Sleep' }
          ]
ErrataSlip::load_file('errata.yaml').correct!(records)
p records
=> [
      { name: 'Adam', surname: 'Smith', book: 'The Wealth of Nations'  },
      { name: 'Adam', surname: 'Sandler', book: 'Go the F**k to Sleep' }
   ]
```

## Compatibility

ErrataSlip is tested against MRI 1.9.3, 2.0.0 and 2.1.0

## Credits

Artem Fedorov: artem at mail dot ru

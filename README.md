# ErrataSlip

Apply corrections from yaml file to array of records. Useful in scraping when one needs to apply errata to scraped data.

## Installation

Add this line to your application's Gemfile:

    gem 'errata_slip'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install errata_slip

## Usage

You are expected to have array of hashes and apply corrections to it.

### Single field match & change

You can easily fix missplelings or inaccuracies in scraped data or other input.

In this example we change all names from 'Adaam' to 'Adam'

errata.yaml
```YAML
---
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

### Multiple fields match & change

You can match several fields and correct several fields.

We search for all records with name 'Hillary' and surname 'Clinton' and change them to 'Monika' and 'Lewinsky'
respectively.

errata.yaml
```YAML
---
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

### Multiple fields match & change

'Match' fields and 'correct' fields shouldn't be the same.

This example searches all records with name 'Adam' and changes surname to 'Smith' and book to 'The Wealth of Nations'.

errata.yaml
```YAML
---
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

### Multiple fields match & adding new fields

We can not only change existing fields, but also add new ones. The syntax is the same.

errata.yaml
```YAML
---
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



## Contributing

1. Fork it ( http://github.com/artemf/errata_slip/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

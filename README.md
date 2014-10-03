# InteractiveS3 [![Build Status](https://travis-ci.org/yamayo/interactive_s3.svg?branch=master)](https://travis-ci.org/yamayo/interactive_s3)
InteractiveS3 is an interactive shell that can be easily extended with commands using a `aws s3` in the [AWS Command Line Interface](http://docs.aws.amazon.com/cli/latest/index.html).

## Demo
TODO:

## Requirements

* Ruby (~> 2.0.0)
* AWS CLI (=> 1.4.0)

## Installation

```
$ gem install interactive_s3
```

## Available commands

- cd
- pwd
- lls
- exit

and `aws s3` commands.

## Usage

```
$ is3
s3> ls
2014-08-07 00:22:58 my-bucket
s3> cd my-bucket
s3://my-bucket> ls
2014-08-11 00:23:56          4 .
2014-08-20 01:31:34          5 foo
2014-08-10 01:26:36         88 bar.txt
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/interactive_s3/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# InteractiveS3 [![Build Status](https://travis-ci.org/yamayo/interactive_s3.svg?branch=master)](https://travis-ci.org/yamayo/interactive_s3) [![Code Climate](https://codeclimate.com/github/yamayo/interactive_s3/badges/gpa.svg)](https://codeclimate.com/github/yamayo/interactive_s3)
InteractiveS3 is an interactive shell that can be easily extended with commands using a `aws s3` in the [AWS Command Line Interface](http://docs.aws.amazon.com/cli/latest/index.html).

## Requirements
* Ruby (=> 2.0.0)
* AWS CLI (~> 1.5.1)

## Installation
```sh
$ gem install interactive_s3
```

## Usage

### Start
InteractiveS3 is run from the command line.

```sh
$ is3
```

### Available commands

- **cd** : Change the current path.
- **pwd** : Show the current path.
- **lls** : Show local file list.
- **exit** : Quit InteractiveS3.

And `aws s3` commands.  

### Examples

```sh
s3> ls
2014-08-07 00:22:58 my-bucket
s3> cd my-bucket
s3://my-bucket> ls
2014-08-11 00:23:56          4 .
2014-08-20 01:31:34          5 foo
s3://my-bucket> lls
bar.txt
```

A line of input that begins with a ':' will be forwarded to the local path prefix.

```sh
s3://my-bucket> cp :bar.txt .
upload: ./bar.txt to s3://mybucket/bar.txt
s3://my-bucket> ls
2014-08-11 00:23:56          4 .
2014-08-20 01:31:34          5 foo
2014-10-19 22:37:43         31 bar.txt
```

## Inspired By

* [gitsh](https://github.com/thoughtbot/gitsh)
* [pry](https://github.com/pry/pry)

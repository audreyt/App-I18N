
# App::Po

## Description

App::Po borrows some good stuff from Jifty::I18N and tries to provide a general
po management script for all frameworks | applications. 


## Basic flow


### Basic po file manipulation:

parse strings from `lib` path:

    $ cd app
    $ po parse lib

this will generate:

    po/app.pot

please modify the CHARSET in po/app.pot.

    ... modify CHARSET ...

create new language file (po file):

    po lang en
    po lang fr
    po lang ja
    po lang zh_TW

this will generate:

    po/en.po
    po/fr.po
    po/ja.po
    po/zh_TW.po

do translations

    ....

when you added more message in your application. you might need to update po
messages, but you dont have to delete/recreate these po files, you can just parse your messages again
all of your translations will be kept. eg:

    $ po parse parse lib

do translation again ...



### Generate locale and mo file for php-gettext or anyother gettext i18n app:

parse strings from `.` path and use --locale (locale directory structure) , --mo (generate mo file) option:

    $ cd app
    $ po parse --locale --mo .

this will generate:
    
    po/app.pot

please modify the CHARSET in po/app.pot.

    ... modify CHARSET ...

create new language file (po file and mo file) in locale directory structure:

    $ po lang  --locale --mo en
    $ po lang  --locale --mo zh_TW

this will generate:

    po/en/LC_MESSAGES/app.po
    po/en/LC_MESSAGES/app.mo
    po/zh_TW/LC_MESSAGES/app.po
    po/zh_TW/LC_MESSAGES/app.mo

(you can use --podir option to generate those stuff to other directory)

    ... do translation here ...

if you use mo file , you might need to update mo file.

    $ po update --mo


For example:

-Locale-Maketext-Lexicon-0.82  % tree po 

    po
    |-- en
    |   `-- LC_MESSAGES
    |       |-- locale-maketext-lexicon-0.82.mo
    |       `-- locale-maketext-lexicon-0.82.po
    |-- locale-maketext-lexicon-0.82.pot
    `-- zh_TW
        `-- LC_MESSAGES
            |-- locale-maketext-lexicon-0.82.mo
            `-- locale-maketext-lexicon-0.82.po

## Usage

create dictionary files for language:

	$ po lang zh_tw en

parse i18n strings:

	$ po parse bin lib static share/web/static/js ...

start a web server to edit po file:

    $ po server -f po/en.po

start a web server to edit po file of specified language:

    $ po server --lang en

extract message from files and start a web server:

    $ po server --dir lib --dir share/static --lang en

## **TODO**

* Initialize a system-side i18n database:

	po initdb 

* Initialize a temporary SQLite database for collaborative editing, and write
back when INT/TERM signal recevied or could be triggered by a submit button.

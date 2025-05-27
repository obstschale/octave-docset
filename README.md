# Octave docset

| Key                     | Value                                     |
| ----------------------- | ----------------------------------------- |
| Author                  | Hans-Helge Buerger                        |
| Current Octave Version: | v10.1.0                                   |
| Last Update:            | 17, May 2025                              |
| Twitter                 | [Twitter](https://twitter.com/obstschale) |

[Octave](http://www.gnu.org/software/octave/) is a programming language for matrix mathematical calculations. It is very similar to [MatLab](http://www.mathworks.de/products/matlab/) and its syntax is almost interchangable. I use Octave at university for _Machine Learning_ and _Speech Processing_ calculations.

[Dash](http://kapeli.com/dash) is an API Documentation Browser and Code Snippet Manager for Mac. If you are using Windows or Linux you probably want to have a look at [Zeal](http://zealdocs.org/) which is quite similar to Dash.

### Installation for Dash

Just download this [docset](https://github.com/obstschale/octave-docset/archive/master.zip) and unzip it. To install it just double-click on `Octave.docset` and Dash will add this docset.

### Installation for Zeal (Linux or Windows)

To manually install a docket in Zeal you need to download the [docset](https://github.com/obstschale/octave-docset/archive/master.zip) and copy the docset-folder into `%HOMEPATH%\AppData\zeal\docset\`. Restart Zeal and Octave should be loaded automatically.

---

### Generate docset

The docset is generated with a [Python script](https://github.com/obstschale/octave-docset/blob/master/octdoc2set.py) and the [original HTML documentation](http://www.gnu.org/software/octave/support.html). To generate the docset simply clone the repository and you have to change the version variable in `build.sh` (check the link whether the doc version really exists). Then run `./build.sh`. The script will download the docs and will create an `Octave.tgz` file, which is ready for a pull request for [Kapeli/Dash-User-Contributions](https://github.com/Kapeli/Dash-User-Contributions).

### Requirements

```
sqlite3==3.8.x
beautifulsoup4==4.5.1
bs4==0.0.1
```

### Report Bugs

Please report all bugs or issues to the original repo > [Repo Issues](https://github.com/obstschale/octave-docset/issues)

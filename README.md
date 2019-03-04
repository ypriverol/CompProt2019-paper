# Computational Proteomics Paper 

## Description 

This repository contains the manuscript in computational proteomics. Our aim here is to describe how the proteomics community is developing and using bioinformatics software. 

## Commenting and contributing 

We hope to write a manuscript by the computational proteomics community that discuss the challenges, oportunities and drawbacks in current Computational Pooteomics by 2019. Feel free to open an issue if there is any point you would like to raise or discuss.

- Anyone from the community is encorage to discuss topics for the manuscript, including structure, titles, topics, etc. This can be done by opening an issue in [issues](https://github.com/ypriverol/github-paper/issues). 

- and/or pull
requests.~~

- ~~Feel free to browse through existing/past issues and if one seems
related, comment on it. If no existing issue seems appropriate, a new
issue can be opened to discuss the suggestion. In particular, we would
appreciate discussing more substantial changes (for example suggestion
of new rules) in a dedicated issue before sending a pull request.~~

~~If you are new to Git, read the
[manuscript](https://github.com/ypriverol/github-paper/blob/master/document/manuscript.md)
and
[*A Quick Introduction to Version Control with Git and GitHub*](http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004668) -
your input would be most valuable.~~

~~If, based on your contribution, you would like to be added as a
co-author, please open an issue and provide your name and affiliation
and a short description of your contribution or a link to the relevant
issue and pull request.~~

## Conversion to PLoS LaTeX

- **Any modifications to the text should be made to the
  `manuscript.md` file.** This file is then converted to LaTeX using
  `pandoc` and included in the main tex file. 

- **Any modification to the title or authors should be made to
  `manuscript-plos.tex`, following the syntax defined therein**

Then, type

```
make manuscript-plos.tex
```

- Only commit `manuscript-plos.pdf`. Temporary files will be ignored
  by git; to clean them up:

```
make clean
```

## Disclaimer

The authors have no affiliation with [GitHub](https://github.com/),
nor any commercial entity mentioned in this article. The views
described here reflect our own views without input from any third party
organisation.

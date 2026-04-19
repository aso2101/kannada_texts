# Kannada Texts Project

## Texts included so far

- *Ādipurāṇaṁ* of Pampa (ಪಂಪನ ಆದಿಪುರಾಣಂ), 941
- *Vikramārjunavijayaṁ* of Pampa (ಪಂಪನ ವಿಕ್ರಮಾರ್ಜುನವಿಜಯಂ), 941
- *Śāntipurāṇaṁ* of Ponna (ಪೊನ್ನನ ಶಾಂತಿಪುರಾಣಂ), 953
- *Sāhasabhīmavijayaṁ* of Ranna (ರನ್ನ, ಸಾಹಸಭೀಮವಿಜಯಂ)
- *Rannanighaṇṭu* of Ranna (ರನ್ನನ ನಿಘಂಟು)
- *Vardhamānapurāṇaṁ* of Nāgavarman II (ಎರಡನೆಯ ನಾಗವರ್ಮನ ವರ್ಧಮಾನಪುರಾಣಂ), ca. 1042
- *Kāvyāvalōkanaṁ* of Nāgavarman II (ಎರಡನೆಯ ನಾಗವರ್ಮನ ಕಾವ್ಯಾವಲೋಕನಂ), ca. 1042
- *Karṇāṭakabhāṣābhūṣaṇaṁ* of Nāgavarman II (ಎರಡನೆಯ ನಾಗವರ್ಮನ ಕರ್ಣಾಟಕಭಾಷಾಭೂಷಣಂ), ca. 1042 (note that this text is in *Sanskrit* with Kannada examples)
- *Anantanāthapurāṇaṁ* of Janna (ಜನ್ನ, ಅನಂತನಾಥಪುರಾಣಂ)

## Directory structure

    kannada_texts
    ┃ ┗  README.md
    ┃ ┗  meter.md [GENERATED]
    ┣ 📜 tei
    ┣ 📜 txt [GENERATED]
    ┣ 📜 raw
    ┣ 📜 scripts
    ┣ 📜 schemas

The `raw` folder contains the **raw** data from either OCR or double-keyboarding in Kannada script.

The `tei` folder contains the **structured** and **transliterated** data in TEI format, based on the raw data. These files are the basis for all of the other transformations (plain text, etc.) you will see.

The `txt` folder contains plain text files that are **automatically generated** from the corresponding TEI files using the scripts in the `scripts` folder. They are not to be edited directly.

The `scripts` folder contains python and XSLT scripts used for either restructuring the raw data or for converting the TEI data into downstream formats (such as plain text).

The TEI files are validated against the `tei_all.rnc` schema in the `schemas` folder.

## Acknowledgements and license

Unless specified otherwise, the data provided in this repository is made available under a [CC-BY 4.0 license](https://creativecommons.org/licenses/by/4.0/). This means that you are free to use the data however you’d like, **as long as you acknowledge the original creators of the file.**

The people involved with this project have been:
- [Andrew Ollett](http://prakrit.info) (text processing)
- Krishnaprasada G and [Adishila Publications](https://adishila.com/) (text entry and correction)

# Kannada Texts Project

## Texts included so far

- Pampa
  - *Ādipurāṇaṁ* (ಪಂಪನ ಆದಿಪುರಾಣಂ), 941
  - *Vikramārjunavijayaṁ* (ಪಂಪನ ವಿಕ್ರಮಾರ್ಜುನವಿಜಯಂ), 941
- Ponna
  - *Śāntipurāṇaṁ* (ಪೊನ್ನನ ಶಾಂತಿಪುರಾಣಂ), 953
- Cāvuṇḍarāya
  - *Cāvuṇḍarāyapurāṇaṁ* (ಚಾವುಂಡರಾಯಪುರಾಣಂ/ತ್ರಿಷಷ್ಟಿಶಲಾಕಪುರುಷಚರಿತಂ), ca. 990
- Nāgavarma (I)
  - *Chandōmbudhi* (ಛಂದೋಂಬುಧಿ), ca. 995
- Ranna
  - *Sāhasabhīmavijayaṁ* (ರನ್ನ, ಸಾಹಸಭೀಮವಿಜಯಂ), ca. 1000
  - *Rannanighaṇṭu* (ರನ್ನನ ನಿಘಂಟು), ca. 1000
- Nāgavarma (II)
  - *Vardhamānapurāṇaṁ* (ಎರಡನೆಯ ನಾಗವರ್ಮನ ವರ್ಧಮಾನಪುರಾಣಂ), ca. 1042
  - *Kāvyāvalōkanaṁ* (ಎರಡನೆಯ ನಾಗವರ್ಮನ ಕಾವ್ಯಾವಲೋಕನಂ), ca. 1042
  - *Karṇāṭakabhāṣābhūṣaṇaṁ* (ಎರಡನೆಯ ನಾಗವರ್ಮನ ಕರ್ಣಾಟಕಭಾಷಾಭೂಷಣಂ), ca. 1042 (note that this text is in *Sanskrit* with Kannada examples)
- Nāgavarma (III)
  - *Karṇāṭa-kādambari* (ಕರ್ಣಾಟಕಾದಂಬರಿ)
- Harihara
  - *Pampāśatakaṁ* (ಪಂಪಾಶತಕಂ)
  - *Rakṣāśatakaṁ* (ರಕ್ಷಾಶತಕಂ)
- Rāghavāṅka
  - *Siddharāmacaritraṁ* (ಸಿದ್ಧರಾಮಚರಿತ್ರಂ)
- Janna 
  - *Anantanāthapurāṇaṁ* (ಅನಂತನಾಥಪುರಾಣಂ), ca. 1230
- Honnamma
  - *Hadibadeya Dharma* (ಹದಿಬದೆಯ ಧರ್ಮ)
- Kanakadāsa
  - *Naḷacaritre* (ನಳಚರಿತ್ರೆ)
  - *Rāmadhānyacaritre* (ರಾಮಧಾನ್ಯಚರಿತ್ರೆ)
- Ratnākaravarṇi
  - *Aparājitēśvaraśatakaṁ* (ಅಪರಾಜಿತೇಶ್ವರಶತಕಂ)
- Anonymous (the author is unknown, despite the traditional attribution to Śivakōṭyācārya)
  - *Vaḍḍārādhane* (ವಡ್ಡಾರಾಧನೆ)

Plus the corpus of inscriptions included in G. S. Gai’s *Historical Grammar of Old Kannada*. 

The six texts of Harihara (*Pampāśatakaṁ*, *Rakṣāśatakaṁ*), Rāghavāṅka, Honnamma and Kanakadāsa (*Naḷacaritre*, *Rāmadhānyacaritre*) were contributed by Gil Ben-Herut. The editions they were typed from are still to be identified in the `sourceDesc` of their TEI headers.

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

## AI-assisted processing and OCR

Five of the files in `tei` were made from scanned books or PDFs with the help of an AI model (Claude, by Anthropic). The tools and the method are documented in `docs/ocr`, and each file's `teiHeader` says what was done to it and how far it has been proofread.

- *Chandōmbudhi*: OCR of the page images (not proofread).
- *Karṇāṭa-kādambari*: OCR of the page images, from two independent readings that were merged; proofread only in part.
- *Vaḍḍārādhane*: the text was extracted from a PDF by decoding its legacy Kannada font (this is not OCR); transliteration and TEI structure were produced with AI assistance (not proofread).
- *Cāvuṇḍarāyapurāṇaṁ*: OCR of the page images of two scans, from two independent readings per page that were merged; not proofread.
- The inscriptions of G. S. Gai (`tei/Gai`): OCR of the page images, from two independent readings per page whose differences were decided against the page images; the whole text was then proofread by Andrew Ollett, and the conversion to ISO-15919 and to TEI was done with scripts.

The OCR output of these texts should be treated as a draft wherever the header does not say that it has been checked.

## Acknowledgements and license

Unless specified otherwise, the data provided in this repository is made available under a [CC-BY 4.0 license](https://creativecommons.org/licenses/by/4.0/). This means that you are free to use the data however you’d like, **as long as you acknowledge the original creators of the file.**

The people involved with this project have been:
- [Andrew Ollett](http://prakrit.info) (text processing)
- Claude (Anthropic): AI-assisted OCR and processing of the five files listed above
- Krishnaprasada G and [Adishila Publications](https://adishila.com/) (text entry and correction)
- Gil Ben-Herut (contributor of the texts of Harihara, Rāghavāṅka, Honnamma and Kanakadāsa)

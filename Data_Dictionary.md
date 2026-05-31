Table1 (Patient Information)
| Column Name         | Data Type    | Description                                                          |
| ------------------- | ------------ | -------------------------------------------------------------------- |
| patient_id          | VARCHAR(255) | Unique identifier for each patient. Primary Key.                     |
| smoke               | BOOLEAN      | Indicates whether the patient smokes (`TRUE`/`FALSE`).               |
| drink               | BOOLEAN      | Indicates whether the patient consumes alcohol (`TRUE`/`FALSE`).     |
| background_father   | VARCHAR(255) | Father's skin type/background classification.                        |
| background_mother   | VARCHAR(255) | Mother's skin type/background classification.                        |
| age                 | INTEGER      | Age of the patient in years.                                         |
| pesticide           | BOOLEAN      | Indicates exposure to pesticides.                                    |
| gender              | VARCHAR(10)  | Patient gender.                                                      |
| skin_cancer_history | BOOLEAN      | Indicates whether the patient has a personal history of skin cancer. |
| cancer_history      | BOOLEAN      | Indicates whether the patient has a history of any cancer.           |
| has_piped_water     | BOOLEAN      | Indicates access to piped water.                                     |
| has_sewage_system   | BOOLEAN      | Indicates access to a sewage system.                                 |


Table2 (Lesion Information)
| Column Name | Data Type        | Description                                                                             |
| ----------- | ---------------- | --------------------------------------------------------------------------------------- |
| lesion_id   | INTEGER          | Unique identifier for each lesion.                                                      |
| patient_id  | VARCHAR(255)     | Patient identifier linking the lesion to a patient. Foreign Key to `table1.patient_id`. |
| fitspatrick | INTEGER          | Fitzpatrick skin type classification (typically 1–6).                                   |
| region      | VARCHAR(255)     | Anatomical region where the lesion is located.                                          |
| diameter_1  | DOUBLE PRECISION | First lesion diameter measurement.                                                      |
| diameter_2  | DOUBLE PRECISION | Second lesion diameter measurement.                                                     |
| diagnostic  | VARCHAR(255)     | Clinical diagnosis of the lesion.                                                       |
| itch        | BOOLEAN          | Indicates whether the lesion causes itching.                                            |
| grew        | BOOLEAN          | Indicates whether the lesion has increased in size.                                     |
| hurt        | BOOLEAN          | Indicates whether the lesion causes pain.                                               |
| changed     | BOOLEAN          | Indicates whether the lesion has changed appearance.                                    |
| bleed       | BOOLEAN          | Indicates whether the lesion has bled.                                                  |
| elevation   | BOOLEAN          | Indicates whether the lesion is elevated above the skin surface.                        |
| img_id      | VARCHAR(255)     | Identifier for the lesion image.                                                        |
| biopsed     | BOOLEAN          | Indicates whether a biopsy was performed.                                               |


Diagnostic Categories
| Code | Description             |
| ---- | ----------------------- |
| ACK  | Actinic Keratosis       |
| BCC  | Basal Cell Carcinoma    |
| MEL  | Melanoma                |
| NEV  | Nevus (Mole)            |
| SCC  | Squamous Cell Carcinoma |
| SEK  | Seborrheic Keratosis    |


Relationship Diagram
table1
┌──────────────┐
│ patient_id PK│
└──────┬───────┘
       │
       │ 1-to-Many
       │
┌──────▼───────┐
│ table2       │
│ lesion_id PK │
│ patient_id FK│
└──────────────┘

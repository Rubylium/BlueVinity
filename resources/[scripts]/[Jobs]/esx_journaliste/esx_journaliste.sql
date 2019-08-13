SET @job_name = 'journaliste';
SET @society_name = 'society_journaliste';
SET @job_Name_Caps = 'journaliste';

INSERT INTO `addon_account` (name, label, shared) VALUES
  (society_journaliste, journaliste, 1);

INSERT INTO `addon_inventory` (name, label, shared) VALUES
  (society_journaliste, journaliste, 1);

INSERT INTO `datastore` (name, label, shared) VALUES 
    (society_journaliste, journaliste, 1);

INSERT INTO `jobs` (name, label, whitelisted) VALUES
  (journaliste, journaliste, 1);

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  (journaliste, 0, 'stagiaire', 'Stagiaire', 250, '{}', '{}'),
  (journaliste, 1, 'reporter', 'Reporter', 350, '{}', '{}'),
  (journaliste, 2, 'investigator', 'Enqu�teur', 400, '{}', '{}'),
  (journaliste, 3, 'boss', "R�dac' chef", 450, '{}', '{}');
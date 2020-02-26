# region categories
CREATE TABLE IF NOT EXISTS `v7ocf_organizer_categories` (
    `id`       INT(11) UNSIGNED    NOT NULL AUTO_INCREMENT,
    `alias`    VARCHAR(255)                 DEFAULT NULL,
    `code`     VARCHAR(60)         NOT NULL,
    `name_de`  VARCHAR(150)        NOT NULL,
    `name_en`  VARCHAR(150)        NOT NULL,
    `active`   TINYINT(1) UNSIGNED NOT NULL DEFAULT 1,
    `suppress` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `alias` (`alias`),
    UNIQUE INDEX `code` (`code`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci;

INSERT IGNORE INTO `v7ocf_organizer_categories` (`id`, `code`, `name_de`, `name_en`)
SELECT `id`, `gpuntisID`, `name`, `name`
FROM `v7ocf_thm_organizer_plan_programs`;

UPDATE `v7ocf_organizer_programs` AS p
    INNER JOIN `v7ocf_thm_organizer_plan_programs` AS pp ON pp.`programID` = p.`id`
SET p.`categoryID` = pp.`id`
WHERE pp.`programID` IS NOT NULL;

INSERT IGNORE INTO `v7ocf_organizer_associations` (`id`, `organizationID`, `categoryID`)
SELECT (`id`, `departmentID`, `programID`)
FROM `v7ocf_thm_organizer_department_resources`
WHERE `programID` IS NOT NULL;


ALTER TABLE `v7ocf_organizer_programs`
    ADD CONSTRAINT `program_categoryID_fk` FOREIGN KEY (`categoryID`) REFERENCES `v7ocf_organizer_categories` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE;
# endregion

# region groups
CREATE TABLE IF NOT EXISTS `v7ocf_organizer_groups` (
    `id`          INT(11) UNSIGNED    NOT NULL AUTO_INCREMENT,
    `alias`       VARCHAR(255)                 DEFAULT NULL,
    `code`        VARCHAR(60)         NOT NULL,
    `name_de`     VARCHAR(150)        NOT NULL,
    `name_en`     VARCHAR(150)        NOT NULL,
    `active`      TINYINT(1) UNSIGNED NOT NULL DEFAULT 1,
    `categoryID`  INT(11) UNSIGNED    NOT NULL,
    `fullName_de` VARCHAR(200)        NOT NULL,
    `fullName_en` VARCHAR(200)        NOT NULL,
    `gridID`      INT(11) UNSIGNED             DEFAULT 1,
    `suppress`    TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `alias` (`alias`),
    UNIQUE INDEX `entry` (`code`, `categoryID`),
    INDEX `categoryID` (`categoryID`),
    UNIQUE `code` (`code`),
    INDEX `gridID` (`gridID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci;

INSERT IGNORE INTO `v7ocf_organizer_groups` (`id`, `code`, `categoryID`, `gridID`, `name_de`, `name_en`, `fullName_de`,
                                             `fullName_en`)
SELECT `id`,
       `gpuntisID`,
       `programID`,
       `gridID`,
       `name`,
       `name`,
       `full_name`,
       `full_name`
FROM `v7ocf_thm_organizer_plan_pools`;

# add associations table insert statement
INSERT x;

ALTER TABLE `v7ocf_organizer_groups`
    ADD CONSTRAINT `group_categoryID_fk` FOREIGN KEY (`categoryID`) REFERENCES `v7ocf_organizer_categories` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `group_gridID_fk` FOREIGN KEY (`gridID`) REFERENCES `v7ocf_organizer_grids` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE;

ALTER TABLE `v7ocf_organizer_pools`
    ADD CONSTRAINT `pool_groupID_fk` FOREIGN KEY (`groupID`) REFERENCES `v7ocf_organizer_groups` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE;
# endregion

# region group publishing
CREATE TABLE IF NOT EXISTS `v7ocf_organizer_group_publishing` (
    `id`        INT(11) UNSIGNED    NOT NULL AUTO_INCREMENT,
    `groupID`   INT(11) UNSIGNED    NOT NULL,
    `termID`    INT(11) UNSIGNED    NOT NULL,
    `published` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `entry` (`groupID`, `termID`),
    INDEX `groupID` (`groupID`),
    INDEX `termID` (`termID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci;

INSERT IGNORE INTO `v7ocf_organizer_group_publishing` (id, groupID, termID, published)
SELECT *
FROM `v7ocf_thm_organizer_plan_pool_publishing`;

ALTER TABLE `v7ocf_organizer_group_publishing`
    ADD CONSTRAINT `group_publishing_groupID_fk` FOREIGN KEY (`groupID`) REFERENCES `v7ocf_organizer_groups` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `group_publishing_termID_fk` FOREIGN KEY (`termID`) REFERENCES `v7ocf_organizer_terms` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;
# endregion

# region associations
ALTER TABLE `v7ocf_organizer_associations`
    ADD CONSTRAINT `association_categoryID_fk` FOREIGN KEY (`categoryID`) REFERENCES `v7ocf_organizer_categories` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `association_groupID_fk` FOREIGN KEY (`groupID`) REFERENCES `v7ocf_organizer_groups` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;
# endregion

# region events
CREATE TABLE IF NOT EXISTS `v7ocf_organizer_events` (
    `id`               INT(11) UNSIGNED    NOT NULL AUTO_INCREMENT,
    `alias`            VARCHAR(255)                 DEFAULT NULL,
    `code`             VARCHAR(60)         NOT NULL COLLATE utf8mb4_bin,
    `name_de`          VARCHAR(150)        NOT NULL,
    `name_en`          VARCHAR(150)        NOT NULL,
    `subjectNo`        VARCHAR(45)         NOT NULL DEFAULT '',
    `campusID`         INT(11) UNSIGNED             DEFAULT NULL,
    `organizationID`   INT(11) UNSIGNED    NOT NULL,
    `active`           TINYINT(1) UNSIGNED NOT NULL DEFAULT 1,
    `contact_de`       TEXT,
    `contact_en`       TEXT,
    `content_de`       TEXT,
    `content_en`       TEXT,
    `courseContact_de` TEXT,
    `courseContact_en` TEXT,
    `deadline`         INT(2) UNSIGNED              DEFAULT 0,
    `description_de`   TEXT,
    `description_en`   TEXT,
    `fee`              INT(3) UNSIGNED              DEFAULT 0,
    `maxParticipants`  INT(4) UNSIGNED              DEFAULT 1000,
    `organization_de`  TEXT,
    `organization_en`  TEXT,
    `pretests_de`      TEXT,
    `pretests_en`      TEXT,
    `preparatory`      TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `registrationType` INT(1) UNSIGNED              DEFAULT NULL,
    `suppress`         TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `alias` (`alias`),
    UNIQUE INDEX `entry` (`code`, `organizationID`),
    INDEX `campusID` (`campusID`),
    INDEX `code` (`code`),
    INDEX `organizationID` (`organizationID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci;

INSERT IGNORE INTO `v7ocf_organizer_events` (`id`, `code`, `name_de`, `name_en`, `subjectNo`)
SELECT DISTINCT `id`, `gpuntisID`, `name`, `name`, `subjectNo`
FROM `v7ocf_thm_organizer_plan_subjects`;

# region extrapolate department values
UPDATE `v7ocf_organizer_events` AS e
    INNER JOIN `v7ocf_thm_organizer_plan_subjects` AS ps ON ps.`id` = e.`id`
SET e.`organizationID` = 1
WHERE ps.`subjectIndex` LIKE 'BAU_%';

UPDATE `v7ocf_organizer_events` AS e
    INNER JOIN `v7ocf_thm_organizer_plan_subjects` AS ps ON ps.`id` = e.`id`
SET e.`organizationID` = 2
WHERE ps.`subjectIndex` LIKE 'EI_%';

UPDATE `v7ocf_organizer_events` AS e
    INNER JOIN `v7ocf_thm_organizer_plan_subjects` AS ps ON ps.`id` = e.`id`
SET e.`organizationID` = 3
WHERE ps.`subjectIndex` LIKE 'ME_%';

UPDATE `v7ocf_organizer_events` AS e
    INNER JOIN `v7ocf_thm_organizer_plan_subjects` AS ps ON ps.`id` = e.`id`
SET e.`organizationID` = 4
WHERE ps.`subjectIndex` LIKE 'LSE_%';

UPDATE `v7ocf_organizer_events` AS e
    INNER JOIN `v7ocf_thm_organizer_plan_subjects` AS ps ON ps.`id` = e.`id`
SET e.`organizationID` = 6
WHERE ps.`subjectIndex` LIKE 'GES_%';

UPDATE `v7ocf_organizer_events` AS e
    INNER JOIN `v7ocf_thm_organizer_plan_subjects` AS ps ON ps.`id` = e.`id`
SET e.`organizationID` = 6
WHERE ps.`subjectIndex` LIKE '%GESUNDHEIT_%';

UPDATE `v7ocf_organizer_events` AS e
    INNER JOIN `v7ocf_thm_organizer_plan_subjects` AS ps ON ps.`id` = e.`id`
SET e.`organizationID` = 14
WHERE ps.`subjectIndex` LIKE 'MNI_%';

UPDATE `v7ocf_organizer_events` AS e
    INNER JOIN `v7ocf_thm_organizer_plan_subjects` AS ps ON ps.`id` = e.`id`
SET e.`organizationID` = 7
WHERE ps.`subjectIndex` LIKE 'W_%';

UPDATE `v7ocf_organizer_events` AS e
    INNER JOIN `v7ocf_thm_organizer_plan_subjects` AS ps ON ps.`id` = e.`id`
SET e.`organizationID` = 8
WHERE ps.`subjectIndex` LIKE 'MUK_%';

UPDATE `v7ocf_organizer_events` AS e
    INNER JOIN `v7ocf_thm_organizer_plan_subjects` AS ps ON ps.`id` = e.`id`
SET e.`organizationID` = 19
WHERE ps.`subjectIndex` LIKE 'FB_%';

UPDATE `v7ocf_organizer_events` AS e
    INNER JOIN `v7ocf_thm_organizer_plan_subjects` AS ps ON ps.`id` = e.`id`
SET e.`organizationID` = 12
WHERE ps.`subjectIndex` LIKE 'THM_%';

UPDATE `v7ocf_organizer_events` AS e
    INNER JOIN `v7ocf_thm_organizer_plan_subjects` AS ps ON ps.`id` = e.`id`
SET e.`organizationID` = 13
WHERE ps.`subjectIndex` LIKE 'ZDH_%';

UPDATE `v7ocf_organizer_events` AS e
    INNER JOIN `v7ocf_thm_organizer_plan_subjects` AS ps ON ps.`id` = e.`id`
SET e.`organizationID` = 11
WHERE ps.`subjectIndex` LIKE 'STK_%';
# endregion

# region set prep course values by event and organization (12 = GI, 13 = ZDH, 14 = MNI, 19 = FB)
UPDATE `v7ocf_organizer_events` AS e
SET `courseContact_de` = '<ul><li><a href="mailto:alexander.dworschak@mni.thm.de" target="_top"><span class="icon-mail"></span>Alexander Dworschak</a><br /><span class="icon-phone"></span>0641 / 309-2394</li><li><a href="mailto:christine.froehlich@mni.thm.de" target="_top"><span class="icon-mail"></span>Christine Fröhlich</a></li></ul>',
    `courseContact_en` = '<ul><li><a href="mailto:alexander.dworschak@mni.thm.de" target="_top"><span class="icon-mail"></span>Alexander Dworschak</a><br /><span class="icon-phone"></span>0641 / 309-2394</li><li><a href="mailto:christine.froehlich@mni.thm.de" target="_top"><span class="icon-mail"></span>Christine Fröhlich</a></li></ul>',
    `description_de`   = 'Grundlegende Themengebiete der allgemeinen, anorganischen und organischen Chemie für technisch-naturwissenschaftliche Studiengänge werden bearbeitet und anhand von Übungsaufgaben gefestigt.',
    `description_en`   = 'Fundamental areas of general, anorganic and organic chemistry for technical and natural science based degree programs are discussed and und practical exercises help to ensure that discussed themes are learned.',
    `maxParticipants`  = 1000,
    `pretests_de`      = 'Wenn Sie unsicher sind ob Sie am Kurs teilnehmen sollten, können Sie deisen Selbsttest absolvieren, um dies herauszufinden.<h6>Aufgaben</h6><ol><li>1a. Wie groß ist die Stoffmengenkonzentration in Mol pro Liter, wenn 49 g H<sub>3</sub>PO<sub>4</sub> mit Wasser zu 1 L Lösung aufgefüllt werden?<br />1b. Wie viel Gramm Natriumfluorid enthalten 250 ml einer Lösung der Konzentration 0,5 mol/L?</li><li>Wie viele Elektronen besitzt das Natriumion im Natriumchlorid?</li><li>Geben Sie die Formeln folgender Stoffe an:<br />a. Schwefelsäure b. Kaliumbromid<br />c. Calciumcarbonat d. Magnesiumchlorid<br />e. Aluminiumsulfat</li><li>&nbsp;Was entsteht beim Zusammengießen von Salzsäure und Natronlauge?</li><li>5a. Welcher Stoff bildet sich beim Verbrennen von Schwefel an der Luft?<br />5b. Wie ändert sich dabei die Oxidationszahl des Schwefels?</li></ol><h6>Lösungen</h6><ol><li>a. 0,5 mol/L<br />b. 5,25 g</li><li>10</li><li>a. H<sub>2</sub>SO<sub>4</sub><br />b. KBr<br />c. CaCO<sub>3</sub><br />d. MgCl<sub>2</sub><br />e. Al<sub>2</sub>(SO<sub>4</sub>)<sub>3</sub></li><li>Natriumchlorid und Wasser</li><li>a. Schwefeldioxid<br />b. von 0 auf +4</li></ol>',
    `pretests_en`      = 'If you are unsure if you should participate in the course, take the placement test below.<h6>Exercises</h6><ol><li>1a. What is the material concentration in Mol per Liter, if 49 g H<sub>3</sub>PO<sub>4</sub>&nbsp;are combined with water to create a 1 L solution?<br />1b. How many grams of Sodium Fluoride are contained in a 250 ml solution with a concentration of 0.5 mol/L?</li><li>How many electrons does an ion of Sodium have in Sodium Chloride?</li><li>Write the formulas for the following molecules:<br />a. Schwefelsäure<br /> b. Potassiumbromide<br />c. Calciumcarbonate<br /> d. Magnesiumchloride<br />e. Aluminiumsulfate</li><li>&nbsp;What is created by pouring together Hydrochloric Acid and Sodium Hydroxide?</li><li>5a. Which material is formed by burning Sulfer in the air?<br />5b. How does this change the oxidization state of the Sulfer?</li></ol><h6>Solutions</h6><ol><li>a. 0.5 mol/L<br />b. 5.25 g</li><li>10</li><li>a. H<sub>2</sub>SO<sub>4</sub><br />b. KBr<br />c. CaCO<sub>3</sub><br />d. MgCl<sub>2</sub><br />e. Al<sub>2</sub>(SO<sub>4</sub>)<sub>3</sub></li><li>Sodium Chloride ande Water</li><li>a. Sulfurdioxide<br />b. from 0 to +4</li></ol>'
WHERE `code` = 'BKC'
  AND `organizationID` IN (14, 12);

UPDATE `v7ocf_organizer_events` AS e
SET `content_de`      = '<ul><li>Brüche</li><li>Gleichungen</li><li>Größen</li><li>Klammern</li><li>Logarithmen</li><li>Potenzen und Wurzeln</li><li>Proportionalität</li><li>Prozentrechnung</li><li>Trigonometrie</li><li>Zahlen</li></ul>',
    `content_en`      = '<ul><li>Braces</li><li>Equations</li><li>Exponents and Roots</li><li>Fractions</li><li>Quantities</li><li>Logarithms</li><li>Percentages</li><li>Proportions</li><li>Trigonometry</li><li>Numbers</li></ul>',
    `description_de`  = 'Es wird das mathematische Grundlagenwissen wiederholt, das von Studienbeginn an in allen technischen, mathematisch-naturwissenschaftlichen und wirtschaftswissenschaftlichen Studiengängen benötigt wird. Beispiele werden besprochen und vertiefende Übungsaufgaben werden durchgearbeitet.',
    `description_en`  = 'The mathematical fundamentals necessary for degree programs in technology, mathematics, natural sciences and economics based degree programs are discussed.',
    `maxParticipants` = 1000,
    `pretests_de`     = 'Wenn sie unsicher sind ob sie am Kurs teilnehmen sollten, können Sie einen Selbsttest absolvieren, um dies herauszufinden.<ul><li>Wenn Sie noch kein Konto bei "THM Moodle für Sonderveranstaltungen und externe Gäste" haben, müssen Sie sich registrieren.<ul><li>Besuchen Sie dazu die <a href="https://moodle-ext.thm.de/login/index.php?authCAS=NOCAS" target="_blank" rel="noopener">Login-Maske</a>.</li><li>Klicken Sie ganz unten auf der Seite auf "Neues Konto anlegen?" um zum Registrierungsformular zu gelangen.</li><li>Füllen Sie die Felder des Registrierungsformulars aus und senden Sie das Formular mit dem Knopf "Mein neues Konto anlegen" ab.</li><li>Schauen Sie nun in das Postfach Ihres Emailkontos, dort erhalten Sie eine Bestätigungsemail mit dem Betreff "account confirmation" (kann einige Zeit in Anspruch nehmen, da der Vorgang vom Administrator manuell durchgeführt wird). Damit ist Ihr Konto aktiviert.</li></ul></li><li>Besuchen Sie nun wieder die Seite mit der <a href="https://moodle-ext.thm.de/login/index.php?authCAS=NOCAS" target="_blank" rel="noopener">Login-Maske</a> und loggen Sie sich mit Ihren Zugangsdaten ein.</li><li>Gehen Sie dann auf die Seite <a href="https://moodle-ext.thm.de/course/view.php?id=63" target="_blank" rel="noopener">Vortest Mathematik Brückenkurs Friedberg</a>.<ul><li>Klicken Sie unten auf "Mathematik Test".</li><li>Geben Sie das Kennwort "vortest" ein.</li></ul></li><li>Bei weiteren Fragen zu Moodle wenden Sie sich an: moodle@thm.de</li></ul>',
    `pretests_en`     = 'If you are unsure if you should participate in the course, we offer placement tests.<ul><li>If you do not have an account with "THM Moodle für Sonderveranstaltungen und externe Gäste", you need to create one.<ul><li>Open the <a href="https://moodle-ext.thm.de/login/index.php?authCAS=NOCAS" target="_blank" rel="noopener">login Mask</a>.</li><li>Click the link "Neues Konto anlegen?" at the bottom in order to get to the registration form.</li><li>Fill out the fields of the registration form and send the form using the button "Mein neues Konto anlegen".</li><li>Wait for an Email with the subject "account confirmation" to arrive in your inbox. (This can take some time as the acceptance is performed manually by the site administrator.) Your account is now active.</li></ul></li><li>Log in using the <a href="https://moodle-ext.thm.de/login/index.php?authCAS=NOCAS" target="_blank" rel="noopener">login mask</a>, your username and password.</li><li>Visit the course <a href="https://moodle-ext.thm.de/course/view.php?id=63" target="_blank" rel="noopener">Vortest Mathematik Brückenkurs Friedberg</a>.<ul><li>Click on "Mathematik Test" towards the bottom.</li><li>Use the password "vortest" to access the test.</li></ul></li><li>For further questions about Moodle write to: <a href="mailto:moodle@thm.de">moodle@thm.de</a></li></ul>'
WHERE `code` = 'BKM'
  AND `organizationID` IN (14, 12, 13, 19);

UPDATE `v7ocf_organizer_events` AS e
SET `description_de`  = 'Das für alle technisch-naturwissenschaftlichen Studiengänge erforderliche physikalische Grundwissen wird wiederholt und gegebenenfalls neu erarbeitet. Dabei werden exemplarisch physikalische Lösungsstrategien entwickelt und mit Hilfe von Übungsaufgaben konkretisiert, überprüft und vertieft.',
    `description_en`  = 'The technical and physical fundamentals necessary for degree programs in technology are discussed superficially and as necessary at depth. Throughout examples of solutions to physical problems are developed and internalized with the help of practical exercises.',
    `maxParticipants` = 1000,
    `pretests_de`     = 'Wenn sie unsicher sind ob sie am Kurs teilnehmen sollten, können Sie einen Selbsttest absolvieren, um dies herauszufinden.<ul><li>Wenn Sie noch kein Konto bei "THM Moodle für Sonderveranstaltungen und externe Gäste" haben, müssen Sie sich registrieren.<ul><li>Besuchen Sie dazu die <a href="https://moodle-ext.thm.de/login/index.php?authCAS=NOCAS" target="_blank" rel="noopener">Login-Maske</a>.</li><li>Klicken Sie ganz unten auf der Seite auf "Neues Konto anlegen?" um zum Registrierungsformular zu gelangen.</li><li>Füllen Sie die Felder des Registrierungsformulars aus und senden Sie das Formular mit dem Knopf "Mein neues Konto anlegen" ab.</li><li>Schauen Sie nun in das Postfach Ihres Emailkontos, dort erhalten Sie eine Bestätigungsemail mit dem Betreff "account confirmation" (kann einige Zeit in Anspruch nehmen, da der Vorgang vom Administrator manuell durchgeführt wird). Damit ist Ihr Konto aktiviert.</li></ul></li><li>Besuchen Sie nun wieder die Seite mit der <a href="https://moodle-ext.thm.de/login/index.php?authCAS=NOCAS" target="_blank" rel="noopener">Login-Maske</a> und loggen Sie sich mit Ihren Zugangsdaten ein.</li><li>Gehen Sie dann auf die Seite <a href="https://moodle-ext.thm.de/course/view.php?id=65" target="_blank" rel="noopener">Vortest Physik Brückenkurs Friedberg</a>.<ul><li>Klicken Sie unten auf "Physik Test".</li><li>Geben Sie das Kennwort "vortest" ein.</li></ul></li><li>Bei weiteren Fragen zu Moodle wenden Sie sich an: moodle@thm.de</li></ul>',
    `pretests_en`     = 'If you are unsure if you should participate in the course, we offer placement tests.<ul><li>If you do not have an account with "THM Moodle für Sonderveranstaltungen und externe Gäste", you need to create one.<ul><li>Open the <a href="https://moodle-ext.thm.de/login/index.php?authCAS=NOCAS" target="_blank" rel="noopener">login Mask</a>.</li><li>Click the link "Neues Konto anlegen?" at the bottom in order to get to the registration form.</li><li>Fill out the fields of the registration form and send the form using the button "Mein neues Konto anlegen".</li><li>Wait for an Email with the subject "account confirmation" to arrive in your inbox. (This can take some time as the acceptance is performed manually by the site administrator.) Your account is now active.</li></ul></li><li>Log in using the <a href="https://moodle-ext.thm.de/login/index.php?authCAS=NOCAS" target="_blank" rel="noopener">login mask</a>, your username and password.</li><li>Visit the course <a href="https://moodle-ext.thm.de/course/view.php?id=65" target="_blank" rel="noopener">Vortest Physik Brückenkurs Friedberg</a>.<ul><li>Click on "Physik Test" towards the bottom.</li><li>Use the password "vortest" to access the test.</li></ul></li><li>For further questions about Moodle write to: <a href="mailto:moodle@thm.de">moodle@thm.de</a></li></ul>'
WHERE `code` = 'BKPh'
  AND `organizationID` IN (14, 12, 19);

UPDATE `v7ocf_organizer_events` AS e
SET `content_de`       = 'Wir führen Sie in die Bedienung eines Rechners ein und zeigen, wie einfache Programme erstellt und zur Ausführung gebracht werden. Schwerpunkte sind eine erste Einführung in das für das Programmieren wichtige algorithmische Denken und die Vermittlung praktischer Fertigkeiten im Umgang mit einem Computer. Im Rahmen des Kurses kann das Erlernte an Rechnern der Hochschule ausprobiert werden, aber <strong>wenn möglich einen eigenen Laptop mitbringen</strong>.',
    `content_en`       = 'We instruct you in the use of computers and show how simple programs are created and brought to execution. This course emphasizes algorithmic thinking as is necessary for programming and training in practical skills for efficient computer use. In the context of the course, learned skills can be put directly into practice on the university''s own computers, however, <strong>if possible, please bring your own laptop with</strong>.',
    `courseContact_de` = '<ul><li><a href="mailto:alexander.dworschak@mni.thm.de" target="_top"><span class="icon-mail"></span>Alexander Dworschak</a><br /><span class="icon-phone"></span>0641 / 309-2394</li><li><a href="mailto:christopher.schoelzel@mni.thm.de" target="_top"><span class="icon-mail"></span>Christopher Schölzel</a><br /><span class="icon-phone"></span>0641 / 309-2459</li></ul>',
    `courseContact_en` = '<ul><li><a href="mailto:alexander.dworschak@mni.thm.de" target="_top"><span class="icon-mail"></span>Alexander Dworschak</a><br /><span class="icon-phone"></span>0641 / 309-2394</li><li><a href="mailto:christopher.schoelzel@mni.thm.de" target="_top"><span class="icon-mail"></span>Christopher Schölzel</a><br /><span class="icon-phone"></span>0641 / 309-2459</li></ul>',
    `description_de`   = 'Der Kurs bietet eine Einführung in das Programmieren in Java und richtet sich an Studierende, die über keine oder sehr geringe Erfahrungen im Programmieren verfügen und sich in einem Studiengang eingeschrieben haben, in dem Programmierkenntnisse von Bedeutung sind.',
    `description_en`   = 'The course offers an introduction to programmin in Java and is directed at students, which possess little to no experience in programming and have registered for a degree program in which the ability to program is of relevance.',
    `maxParticipants`  = 300,
    `pretests_de`      = 'Wenn sie unsicher sind ob sie am Kurs teilnehmen sollten, können Sie einen Selbsttest absolvieren, um dies herauszufinden.<ul><li>Wenn Sie noch kein Konto bei "THM Moodle für Sonderveranstaltungen und externe Gäste" haben, müssen Sie sich registrieren.<ul><li>Besuchen Sie dazu die <a href="https://moodle-ext.thm.de/login/index.php?authCAS=NOCAS" target="_blank" rel="noopener">Login-Maske</a>.</li><li>Klicken Sie ganz unten auf der Seite auf "Neues Konto anlegen?" um zum Registrierungsformular zu gelangen.</li><li>Füllen Sie die Felder des Registrierungsformulars aus und senden Sie das Formular mit dem Knopf "Mein neues Konto anlegen" ab.</li><li>Schauen Sie nun in das Postfach Ihres Emailkontos, dort erhalten Sie eine Bestätigungsemail mit dem Betreff "account confirmation" (kann einige Zeit in Anspruch nehmen, da der Vorgang vom Administrator manuell durchgeführt wird). Damit ist Ihr Konto aktiviert.</li></ul></li><li>Besuchen Sie nun wieder die Seite mit der <a href="https://moodle-ext.thm.de/login/index.php?authCAS=NOCAS" target="_blank" rel="noopener">Login-Maske</a> und loggen Sie sich mit Ihren Zugangsdaten ein.</li><li>Gehen Sie dann auf die Seite <a href="https://moodle-ext.thm.de/course/view.php?id=77" target="_blank" rel="noopener">Vortest Programmieren Brückenkurs</a>.<ul><li>Klicken Sie unten auf "Programmieren Test".</li><li>Geben Sie das Kennwort "vortest" ein.</li></ul></li><li>Bei weiteren Fragen zu Moodle wenden Sie sich an: moodle@thm.de</li></ul>',
    `pretests_en`      = 'If you are unsure if you should participate in the course, we offer placement tests.<ul><li>If you do not have an account with "THM Moodle für Sonderveranstaltungen und externe Gäste", you need to create one.<ul><li>Open the <a href="https://moodle-ext.thm.de/login/index.php?authCAS=NOCAS" target="_blank" rel="noopener">login Mask</a>.</li><li>Click the link "Neues Konto anlegen?" at the bottom in order to get to the registration form.</li><li>Fill out the fields of the registration form and send the form using the button "Mein neues Konto anlegen".</li><li>Wait for an Email with the subject "account confirmation" to arrive in your inbox. (This can take some time as the acceptance is performed manually by the site administrator.) Your account is now active.</li></ul></li><li>Log in using the <a href="https://moodle-ext.thm.de/login/index.php?authCAS=NOCAS" target="_blank" rel="noopener">login mask</a>, your username and password.</li><li>Visit the course <a href="https://moodle-ext.thm.de/course/view.php?id=77" target="_blank" rel="noopener">Vortest Programmieren Brückenkurs</a>.<ul><li>Click on "Programmieren Test" towards the bottom.</li><li>Use the password "vortest" to access the test.</li></ul></li><li>For further questions about Moodle write to: <a href="mailto:moodle@thm.de">moodle@thm.de</a></li></ul>'
WHERE `code` = 'BKPr'
  AND `organizationID` IN (14, 12);

UPDATE `v7ocf_organizer_events` AS e
SET `description_de`  = 'Dieser Kurs vermittelt vertiefte studiumsrelevante Kenntnisse im Umgang mit Office-Produkten und Rechnersystemen in einer theoretischen Einführung und praktischen Übungen an Rechnern der Hochschule.',
    `description_en`  = 'This course conveys in depth knowledge of scholastically relevant methods of working with Office Products and Computers in general, via theoretical introductory lectures and practical exercises on the THM''s computers.',
    `maxParticipants` = 200,
    `pretests_de`     = 'Sollten diese typischen Anwenderprobleme Ihnen nicht unbekannt sein, können Sie bestimmt in diesem Brückenkurs etwas dazu lernen.<ul><li>Sie schreiben Ihre Referate und Ausarbeitungen am PC mit einer Textverarbeitung, wissen aber nicht, was Formatvorlagen sind und Sie haben Probleme, Inhaltsverzeichnisse zu erstellen.</li><li>Ihre Tabellenkalkulation ist für Sie ein besserer Taschenrechner, aber Ihre Formeln funktionieren nach dem Kopieren nicht mehr.</li><li>Ihr Präsentationswerkzeug verwenden Sie wie einen Malkasten, der auch Text beherrscht.</li><li>Bei Ihrem Rechner ist die Festplatte voll mit Sicherungskopien, aber nach einem Plattencrash bekommen Sie das System nicht mehr zum Laufen.</li></ul>',
    `pretests_en`     = 'Should you have experienced these or similar problems, this course should be of help to you.<ul><li>You write reports and papers on your PC with a word processing program, but are unaware of what format templates are and have problems creating a table of contents.</li><li>Your table calculations are written in a style that would also work well on a calculator, as a consequence your functions stop working when they are copied.</li><li>You use your presentation tool primarily as box of paints which can also create texts.</li><li>Your hard drive is full of backup copies, but after your computer crashes you cannot get it to restart.</li></ul>'
WHERE `code` = 'BKWA'
  AND `organizationID` = 19;

UPDATE `v7ocf_organizer_events` AS e
SET `contact_de`       = '<ul><li>Brückenkurse<br /><a href="mailto:brueckenkurse@mnd.thm.de" target="_top"><span class="icon-mail"></span>Hans Christian Arlt, Nicole Müller </a></li><li>Zentrale Studienberatung Friedberg<br /><span class="icon-phone"></span>06031 / 604-7777<br /><span class="icon-clock"></span>07.30 bis 18.00 Uhr</li></ul>',
    `contact_en`       = '<ul><li>Preparatory Courses<br /><a href="mailto:brueckenkurse@mnd.thm.de" target="_top"><span class="icon-mail"></span>Hans Christian Arlt, Nicole Müller </a></li><li>Central Student Counseling Friedberg<br /><span class="icon-phone"></span>06031 / 604-7777<br /><span class="icon-clock"></span>07:30 until 18:00</li></ul>',
    `deadline`         = 5,
    `fee`              = 50,
    `organization_de`  = '<ul><li>Dieser Kurs findet nur am Studienort Friedberg täglich zwischen 09.00 und 16.00 Uhr (inkl. Pausen) statt.</li><li>Die Teilnahmegebühr beträgt 50€ (je Kurs).<ul><li>Die Teilnahmegebühr ist jeweils bei Kursbeginn in bar zu entrichten.</li><li>Andere Zahlungsarten (ec-Karte, Kreditkarte, Scheck, Überweisung, …) können aus organisatorischen Gründen nicht akzeptiert werden.</li><li>Als Beleg für die entrichtete Teilnahmegebühr wird ein Teilnehmerausweis ausgehändigt, sowie Kursmaterialien. Der Ausweiß soll während des Kurses am Person getragen werden.</li></ul></li><li>Die Gruppen- und Raumeinteilung erfolgt jeweils am ersten Kurstag oder in der Woche vor Kursbeginn.<ul><li>Im Falle das die Einteilung vor Kursbeginn stattfindet, werden Sie per Email benachrichtigt.</li><li>Die Einteilung erfolgt nach Fachbereichen / Studiengängen.</li></ul></li><li>Unabhängig vom eigenen Studienort können Studienanfänger/-innen wahlweise an allen Brückenkursen in Studienort Friedberg und Studienort Gießen teilnehmen. Es darf aber nur an jeweils einem Brückenkurs pro Woche teilgenommen werden.</li><li>Die Teilnahme an den Brückenkursen erfordert eine verbindliche Anmeldung zum Kurs auf dieser Seite, in Folge dessen und um Benachrichtigungen zu ermöglichen ist die Registrierungauf dieser Seite ebenso erforderlich.</li><li>Anmeldeschluss ist eine Woche vor dem jeweiligen Kursbeginn. Sichern Sie sich Ihren Teilnehmerplatz durch frühzeitige Anmeldung!</li></ul>',
    `organization_en`  = '<ul><li>This course takes place at Campus Friedberg daily between 9 am and 4 pm (with breaks).</li><li>Course fees are 50€ (per course).<ul><li>Course fees must be paid in cash at the beginning of the course.</li><li>Other payment methods (EC-Cards, credit cards, checks, wire transfers, …) cannot be accepted for organizational reasons.</li><li>As a receipt, course participants will be given an identification badge and course materials. This badge should be carried on their person for the remainder of the course.</li></ul></li><li>The course groups and their respective rooms will be determined on the first day of the course or in the week before the course begins.<ul><li>Should the determination of groups/rooms be decided before the course starts, participants will be notified of the changes per email.</li><li>The groups are formed according to the students'' departments and degree programs.</li></ul></li><li>Independent of the campus where you will be studying, you may take part in any/all preparatory courses of the Friedberg or Gießen Campuses. However only one course may be taken per week.</li><li>Participation in the course requires that you register for the course on this webpage, as a consequence of this, and in order to send notification emails, registration to this site is also required.</li><li>Deadline for registration is a week before the start of the course. Ensure your place by registering early!</li></ul>',
    `preparatory`      = 1,
    `registrationType` = 1
WHERE `code` IN ('BKM', 'BKPh', 'BKWA')
  AND `organizationID` = 19;

UPDATE `v7ocf_organizer_events` AS e
SET `contact_de`       = '<ul><li>Brückenkurse<br /><a href="mailto:tanja.eifler@zdh.thm.de" target="_top"><span class="icon-mail"></span>Tanja Eifler</a><br /><span class="icon-phone"></span>06441 / 2041-450</li><li>ServicePoint<br /><span class="icon-phone"></span>06441 / 2041-0<br /><span class="icon-clock"></span>07.30 bis 18.00 Uhr</li></ul>',
    `contact_en`       = '<ul><li>Preparatory Courses<br /><a href="mailto:tanja.eifler@zdh.thm.de" target="_top"><span class="icon-mail"></span>Tanja Eifler </a><br /><span class="icon-phone"></span>06441 / 2041-450</li><li>ServicePoint<br /><span class="icon-phone"></span>06441 / 2041-0<br /><span class="icon-clock"></span>07:30 until 18:00</li></ul>',
    `deadline`         = 14,
    `fee`              = 0,
    `organization_de`  = '<ul><li>Dieser Kurs findet parallel an den Studienorten <a target="_blank" href="https://www.google.de/maps/place/50.871628,9.707875" rel="noopener">Bad Hersfeld<span class="icon-location"></span></a>, <a target="_blank" href="https://www.google.de/maps/place/50.181754,08.729184" rel="noopener">Bad Vilbel<span class="icon-location"></span></a>, <a target="_blank" href="https://www.google.de/maps/place/51.117264,09.123137" rel="noopener">Bad Wildungen<span class="icon-location"></span></a>, <a target="_blank" href="https://www.google.de/maps/place/50.916110,08.516289" rel="noopener">Biedenkopf<span class="icon-location"></span></a>, <a target="_blank" href="https://www.google.de/maps/place/51.056835,08.791999" rel="noopener">Frankenberg<span class="icon-location"></span></a> und <a target="_blank" href="https://www.google.de/maps/place/50.384112,08.061014" rel="noopener">Limburg<span class="icon-location"></span></a> täglich zwischen 8:00 und 15.30 Uhr (inkl. Pausen) statt.</li><li>Die Teilnahme ist <span style="text-decoration: underline;">ausschließlich</span> für StudiumPlus-Studierende möglich.</li><li>Es fällt keine Teilnahmegebühr an.</li><li>Die Gruppen- &amp; Raumeinteilung erfolgt jeweils am ersten Kurstag Die Teilnahme an den Brückenkursen erfordert eine verbindliche Anmeldung zum Kurs auf dieser Seite, in Folge dessen und um Benachrichtigungen zu ermöglichen ist die Registrierung auf dieser Seite ebenso erforderlich.</li><li>Anmeldeschluss ist <span style="text-decoration: underline;">zwei</span> Wochen vor dem jeweiligen Kursbeginn. Sichern Sie sich Ihren Teilnehmerplatz durch frühzeitige Anmeldung!</li></ul>',
    `organization_en`  = '<ul><li>This place takes course in parallel at the <a target="_blank" href="https://www.google.de/maps/place/50.871628,9.707875" rel="noopener">Bad Hersfeld<span class="icon-location"></span></a>, <a target="_blank" href="https://www.google.de/maps/place/50.181754,08.729184" rel="noopener">Bad Vilbel<span class="icon-location"></span></a>, <a target="_blank" href="https://www.google.de/maps/place/51.117264,09.123137" rel="noopener">Bad Wildungen<span class="icon-location"></span></a>, <a target="_blank" href="https://www.google.de/maps/place/50.916110,08.516289" rel="noopener">Biedenkopf<span class="icon-location"></span></a>, <a target="_blank" href="https://www.google.de/maps/place/51.056835,08.791999" rel="noopener">Frankenberg<span class="icon-location"></span></a> und <a target="_blank" href="https://www.google.de/maps/place/50.384112,08.061014" rel="noopener">Limburg<span class="icon-location"></span></a> locations daily between 8:00 and 15:30 (incl. breaks).</li><li>Participation is limited <span style="text-decoration: underline;">exclusively</span> to StudiumPlus Students.</li><li>There is no participation fee.</li><li>The group- &amp; room assignments take place on the first day of the respective course. Participation requires a binding registration for the course using this website and consequently registration with this website itself. This also enables us to inform course participants of any relevant course information.</li><li>The deadline for registration is <span style="text-decoration: underline;">two</span> weeks before the start of the course. Ensure your place by registering early!</li></ul>',
    `preparatory`      = 1,
    `registrationType` = 1
WHERE `code` = 'BKM'
  AND `organizationID` = 13;

UPDATE `v7ocf_organizer_events` AS e
SET `courseContact_de` = '<ul><li><a href="mailto:hans-rudolf.metz@mni.thm.de" target="_top"><span class="icon-mail"></span>Hans-Rudolf Metz</a><br /><span class="icon-phone"></span>0641 / 309-2329</li></ul>',
    `courseContact_en` = '<ul><li><a href="mailto:hans-rudolf.metz@mni.thm.de" target="_top"><span class="icon-mail"></span>Hans-Rudolf Metz</a><br /><span class="icon-phone"></span>0641 / 309-2329</li></ul>'
WHERE `code` = 'BKM'
  AND `organizationID` IN (14, 12);

UPDATE `v7ocf_organizer_events` AS e
SET `courseContact_de` = '<ul><li><a href="mailto:hans.c.arlt@mnd.thm.de" target="_top"><span class="icon-mail"></span>Hans Christian Arlt</a></li></ul>',
    `courseContact_en` = '<ul><li><a href="mailto:hans.c.arlt@mnd.thm.de" target="_top"><span class="icon-mail"></span>Hans Christian Arlt</a></li></ul>'
WHERE `code` = 'BKPh'
  AND `organizationID` = 19;
# endregion

# region set campusID
UPDATE `v7ocf_organizer_events` AS e
SET `campusID` = (SELECT DISTINCT `campusID`
                  FROM `v7ocf_thm_organizer_subjects` AS s
                           INNER JOIN `v7ocf_thm_organizer_subject_mappings` AS sm ON sm.`subjectID` = s.`id`
                  WHERE sm.`plan_subjectID` = e.`id`);
# endregion

ALTER TABLE `v7ocf_organizer_events`
    ADD CONSTRAINT `event_campusID_fk` FOREIGN KEY (`campusID`) REFERENCES `v7ocf_organizer_campuses` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE;
# endregion

# region event coordinators
CREATE TABLE IF NOT EXISTS `v7ocf_organizer_event_coordinators` (
    `id`       INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `eventID`  INT(11) UNSIGNED NOT NULL,
    `personID` INT(11) UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `entry` UNIQUE (`eventID`, `personID`),
    INDEX `eventID` (`eventID`),
    INDEX `personID` (`personID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci;

INSERT IGNORE INTO `v7ocf_organizer_event_coordinators` (`eventID`, `personID`)
SELECT DISTINCT `plan_subjectID`, `teacherID`
FROM `v7ocf_thm_organizer_subject_teachers` AS st
         INNER JOIN `v7ocf_thm_organizer_subject_mappings` AS sm ON sm.`subjectID` = st.`subjectID`
WHERE `teacherResp` = 1;

ALTER TABLE `v7ocf_organizer_event_coordinators`
    ADD CONSTRAINT `event_coordinator_eventID_fk` FOREIGN KEY (`eventID`) REFERENCES `v7ocf_organizer_events` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `event_coordinator_personID_fk` FOREIGN KEY (`personID`) REFERENCES `v7ocf_organizer_persons` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;
# endregion

# region subject events
CREATE TABLE IF NOT EXISTS `v7ocf_organizer_subject_events` (
    `id`        INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `eventID`   INT(11) UNSIGNED NOT NULL,
    `subjectID` INT(11) UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `entry` (`eventID`, `subjectID`),
    INDEX `eventID` (`eventID`),
    INDEX `subjectID` (`subjectID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci;

INSERT IGNORE INTO `v7ocf_organizer_subject_events` (id, eventID, subjectID)
SELECT `id`, `plan_subjectID`, `subjectID`
FROM v7ocf_thm_organizer_subject_mappings;

ALTER TABLE `v7ocf_organizer_subject_events`
    ADD CONSTRAINT `subject_event_eventID_fk` FOREIGN KEY (`eventID`) REFERENCES `v7ocf_organizer_events` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `subject_event_subjectID_fk` FOREIGN KEY (`subjectID`) REFERENCES `v7ocf_organizer_subjects` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;
# endregion

CREATE TABLE IF NOT EXISTS `#__organizer_associations` (
    `id`             INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `organizationID` INT(11) UNSIGNED NOT NULL,
    `categoryID`     INT(11) UNSIGNED DEFAULT NULL,
    `eventID`        INT(11) UNSIGNED DEFAULT NULL,
    `groupID`        INT(11) UNSIGNED DEFAULT NULL,
    `personID`       INT(11) UNSIGNED DEFAULT NULL,
    `roomID`         INT(11) UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`id`),
    INDEX `categoryID` (`categoryID`),
    INDEX `eventID` (`eventID`),
    INDEX `groupID` (`groupID`),
    INDEX `organizationID` (`organizationID`),
    INDEX `personID` (`personID`),
    INDEX `roomID` (`roomID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_blocks` (
    `id`        INT(11) UNSIGNED    NOT NULL AUTO_INCREMENT,
    `date`      DATE                NOT NULL,
    `dow`       TINYINT(1) UNSIGNED NOT NULL,
    `startTime` TIME                NOT NULL,
    `endTime`   TIME                NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `date` (`date`),
    INDEX `dow` (`endTime`),
    INDEX `startTime` (`startTime`),
    INDEX `endTime` (`endTime`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_buildings` (
    `id`           INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `alias`        VARCHAR(255)              DEFAULT '',
    `campusID`     INT(11) UNSIGNED          DEFAULT NULL,
    `name`         VARCHAR(150)     NOT NULL,
    `location`     VARCHAR(20)      NOT NULL,
    `address`      VARCHAR(255)     NOT NULL,
    `propertyType` INT(1) UNSIGNED  NOT NULL DEFAULT 0
        COMMENT '0 - new/unknown | 1 - owned | 2 - rented/leased',
    PRIMARY KEY (`id`),
    INDEX `campusID` (`campusID`),
    UNIQUE INDEX `entry` (`campusID`, `name`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_campuses` (
    `id`       INT(11) UNSIGNED    NOT NULL AUTO_INCREMENT,
    `alias`    VARCHAR(255)                 DEFAULT '',
    `parentID` INT(11) UNSIGNED             DEFAULT NULL,
    `name_de`  VARCHAR(150)        NOT NULL,
    `name_en`  VARCHAR(150)        NOT NULL,
    `isCity`   TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `location` VARCHAR(20)         NOT NULL,
    `address`  VARCHAR(255)        NOT NULL,
    `city`     VARCHAR(60)         NOT NULL,
    `zipCode`  VARCHAR(60)         NOT NULL,
    `gridID`   INT(11) UNSIGNED             DEFAULT NULL,
    PRIMARY KEY (`id`),
    INDEX `gridID` (`gridID`),
    INDEX `parentID` (`parentID`),
    UNIQUE INDEX `englishName` (`parentID`, `name_en`),
    UNIQUE INDEX `germanName` (`parentID`, `name_de`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_categories` (
    `id`      INT(11) UNSIGNED    NOT NULL AUTO_INCREMENT,
    `alias`   VARCHAR(255)                 DEFAULT '',
    `code`    VARCHAR(60)                  DEFAULT NULL,
    `name_de` VARCHAR(150)        NOT NULL,
    `name_en` VARCHAR(150)        NOT NULL,
    `active`  TINYINT(1) UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `code` (`code`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_colors` (
    `id`      INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `name_de` VARCHAR(150)     NOT NULL,
    `name_en` VARCHAR(150)     NOT NULL,
    `color`   VARCHAR(7)       NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

INSERT IGNORE INTO `#__organizer_colors` (`id`, `name_de`, `name_en`, `color`)
VALUES (1, 'Hellstgruen', 'Lightest Green', '#dfeec8'),
       (2, 'Hellstgrau', 'Lightest Grey', '#d2d6d9'),
       (3, 'Hellstrot', 'Lightest Red', '#e6c4cb'),
       (4, 'Hellstgelb', 'Lightest Yellow', '#fceabf'),
       (5, 'Hellstcyan', 'Lightest Cyan', '#00ffff'),
       (6, 'Hellstblau', 'Lightest Blue', '#bfc9dd'),
       (7, 'Hellgruen', 'Light Green', '#bfdc91'),
       (8, 'Hellgrau', 'Light Grey', '#a4adb2'),
       (9, 'Hellrot', 'Light Red', '#cd8996'),
       (10, 'Hellgelb', 'Light Yellow', '#f9d47f'),
       (11, 'Hellcyan', 'Light Cyan', '#00e2e2'),
       (12, 'Hellblau', 'Light Blue', '#7f93bb'),
       (13, 'Mittelgruen', 'Middling Green', '#a0cb5b'),
       (14, 'Mittelrot', 'Middling Red', '#b54e62'),
       (15, 'Mittelgelb', 'Middling Yellow', '#f7bf40'),
       (16, 'Cyan', 'Cyan', '#00a8a8'),
       (17, 'Grün', 'Green', '#80ba24'),
       (18, 'Mittelgrau', 'Middling Grey', '#77858c'),
       (19, 'Rot', 'Red', '#9c132e'),
       (20, 'Gelb', 'Yellow', '#f4aa00'),
       (21, 'Mittelcyan', 'Middling Cyan', '#00c5c5'),
       (22, 'Mittelblau', 'Middling Blue', '#405e9a'),
       (23, 'Dunkelgrün', 'Dark Green', '#6ea925'),
       (24, 'Dunkelgrau', 'Dark Grey', '#283640'),
       (25, 'Dunkelrot', 'Dark Red', '#82132e'),
       (26, 'Weiß', 'White', '#ffffff'),
       (27, 'Grau', 'Grey', '#4a5c66'),
       (28, 'Schwarz', 'Black', '#000000'),
       (29, 'Dunkelgelb', 'Dark Yellow', '#f0a400'),
       (30, 'Dunkelcyan', 'Dark Cyan', '#008b8b'),
       (31, 'Blau', 'Blue', '#002878'),
       (32, 'Dunkelblau', 'Dark Blue', '#002856'),
       (33, 'Hellstlila', 'Lightest Purple', '#ddd1e7'),
       (34, 'Helllila', 'Light Purple', '#bba3d0'),
       (35, 'Mittellila', 'Middling Purple', '#9975b9'),
       (36, 'Lila', 'Purple', '#7647a2'),
       (37, 'Dunkellila', 'Dark Purple', '#551A8B');

CREATE TABLE IF NOT EXISTS `#__organizer_course_participants` (
    `id`              INT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    `courseID`        INT(11) UNSIGNED NOT NULL,
    `participantID`   INT(11)          NOT NULL,
    `participantDate` DATETIME            DEFAULT NULL COMMENT 'The last date of participant action.',
    `status`          TINYINT(1) UNSIGNED DEFAULT 0 COMMENT 'Possible values: 0 - pending, 1 - accepted',
    `statusDate`      DATETIME            DEFAULT NULL COMMENT 'The last date of status action.',
    `attended`        TINYINT(1) UNSIGNED DEFAULT 0 COMMENT 'Possible values: 0 - unattended, 1 - attended',
    `paid`            TINYINT(1) UNSIGNED DEFAULT 0 COMMENT 'Possible values: 0 - unpaid, 1 - paid',
    PRIMARY KEY (`id`),
    INDEX `courseID` (`courseID`),
    INDEX `participantID` (`participantID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_courses` (
    `id`               INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `campusID`         INT(11) UNSIGNED          DEFAULT NULL,
    `termID`           INT(11) UNSIGNED NOT NULL,
    `groups`           VARCHAR(100)     NOT NULL DEFAULT '',
    `name_de`          VARCHAR(150)              DEFAULT NULL,
    `name_en`          VARCHAR(150)              DEFAULT NULL,
    `description_de`   TEXT,
    `description_en`   TEXT,
    `deadline`         INT(2) UNSIGNED           DEFAULT 0 COMMENT 'The deadline in days for registration before the course starts.',
    `fee`              INT(3) UNSIGNED           DEFAULT 0,
    `maxParticipants`  INT(4) UNSIGNED           DEFAULT 1000,
    `registrationType` INT(1) UNSIGNED           DEFAULT NULL COMMENT 'The method of registration for the lesson. Possible values: NULL - None, 0 - FIFO, 1 - Manual.',
    PRIMARY KEY (`id`),
    INDEX `campusID` (`campusID`),
    INDEX `termID` (`termID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_curricula` (
    `id`        INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `programID` INT(11) UNSIGNED DEFAULT NULL,
    `parentID`  INT(11) UNSIGNED DEFAULT NULL,
    `poolID`    INT(11) UNSIGNED DEFAULT NULL,
    `subjectID` INT(11) UNSIGNED DEFAULT NULL,
    `lft`       INT(11) UNSIGNED DEFAULT NULL,
    `rgt`       INT(11) UNSIGNED DEFAULT NULL,
    `level`     INT(11) UNSIGNED DEFAULT NULL,
    `ordering`  INT(11) UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`id`),
    INDEX `parentID` (`parentID`),
    INDEX `poolID` (`poolID`),
    INDEX `programID` (`programID`),
    INDEX `subjectID` (`subjectID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_degrees` (
    `id`           INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `abbreviation` VARCHAR(25)      NOT NULL,
    `code`         VARCHAR(60)      NOT NULL,
    `name`         VARCHAR(150)     NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

INSERT IGNORE INTO `#__organizer_degrees`
VALUES (2, 'Bachelor of Engineering', 'B.Eng.', 'BE'),
       (3, 'Bachelor of Science', 'B.Sc.', 'BS'),
       (4, 'Bachelor of Arts', 'B.A.', 'BA'),
       (5, 'Master of Engineering', 'M.Eng.', 'ME'),
       (6, 'Master of Science', 'M.Sc.', 'MS'),
       (7, 'Master of Arts', 'M.A.', 'MA'),
       (8, 'Master of Business Administration and Engineering', 'M.B.A.', 'MB'),
       (9, 'Master of Education', 'M.Ed.', 'MH');

CREATE TABLE IF NOT EXISTS `#__organizer_event_coordinators` (
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
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_events` (
    `id`               INT(11) UNSIGNED    NOT NULL AUTO_INCREMENT,
    `alias`            VARCHAR(255)                 DEFAULT '',
    `organizationID`   INT(11) UNSIGNED             DEFAULT NULL,
    `code`             VARCHAR(60)                  DEFAULT NULL,
    `name_de`          VARCHAR(150)        NOT NULL,
    `name_en`          VARCHAR(150)        NOT NULL,
    `subjectNo`        VARCHAR(45)         NOT NULL DEFAULT '',
    `contact_de`       TEXT,
    `contact_en`       TEXT,
    `content_de`       TEXT,
    `content_en`       TEXT,
    `courseContact_de` TEXT,
    `courseContact_en` TEXT,
    `description_de`   TEXT,
    `description_en`   TEXT,
    `organization_de`  TEXT,
    `organization_en`  TEXT,
    `pretests_de`      TEXT,
    `pretests_en`      TEXT,
    `preparatory`      TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `campusID`         INT(11) UNSIGNED             DEFAULT NULL,
    `deadline`         INT(2) UNSIGNED              DEFAULT 0 COMMENT 'The deadline in days for registration before the course starts.',
    `fee`              INT(3) UNSIGNED              DEFAULT 0,
    `maxParticipants`  INT(4) UNSIGNED              DEFAULT 1000,
    `registrationType` INT(1) UNSIGNED              DEFAULT NULL COMMENT 'The method of registration for the lesson. Possible values: NULL - None, 0 - FIFO, 1 - Manual.',
    PRIMARY KEY (`id`),
    UNIQUE INDEX `entry` (`code`, `organizationID`),
    INDEX `campusID` (`campusID`),
    INDEX `code` (`code`),
    INDEX `organizationID` (`organizationID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_field_colors` (
    `id`             INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `colorID`        INT(11) UNSIGNED NOT NULL,
    `fieldID`        INT(11) UNSIGNED NOT NULL,
    `organizationID` INT(11) UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `entry` (`colorID`, `fieldID`, `organizationID`),
    INDEX `colorID` (`colorID`),
    INDEX `fieldID` (`fieldID`),
    INDEX `organizationID` (`organizationID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_fields` (
    `id`      INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `code`    VARCHAR(60)      NOT NULL,
    `name_de` VARCHAR(150)     NOT NULL,
    `name_en` VARCHAR(150)     NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `code` (`code`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_frequencies` (
    `id`      INT(1) UNSIGNED NOT NULL,
    `name_de` VARCHAR(150)    NOT NULL,
    `name_en` VARCHAR(150)    NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE `name_de` (`name_de`),
    UNIQUE `name_en` (`name_en`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

INSERT IGNORE INTO `#__organizer_frequencies` (`id`, `name_de`, `name_en`)
VALUES (0, 'Nach Termin', 'By Appointment'),
       (1, 'Nur im Sommersemester', 'Only Spring/Summer Term'),
       (2, 'Nur im Wintersemester', 'Only Fall/Winter Term'),
       (3, 'Jedes Semester', 'Semesterly'),
       (4, 'Nach Bedarf', 'As Needed'),
       (5, 'Einmal im Jahr', 'Yearly');

CREATE TABLE IF NOT EXISTS `#__organizer_grids` (
    `id`        INT(11) UNSIGNED    NOT NULL AUTO_INCREMENT,
    `code`      VARCHAR(60)                  DEFAULT NULL,
    `name_de`   VARCHAR(150)                 DEFAULT NULL,
    `name_en`   VARCHAR(150)                 DEFAULT NULL,
    `grid`      TEXT
        COMMENT 'A grid object modeled by a JSON string, containing the respective start and end times of the grid blocks.',
    `isDefault` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `code` (`code`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_group_publishing` (
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
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_groups` (
    `id`          INT(11) UNSIGNED    NOT NULL AUTO_INCREMENT,
    `alias`       VARCHAR(255)                 DEFAULT '',
    `code`        VARCHAR(60)                  DEFAULT NULL,
    `categoryID`  INT(11) UNSIGNED             DEFAULT NULL,
    `gridID`      INT(11) UNSIGNED             DEFAULT 1,
    `name_de`     VARCHAR(150)        NOT NULL,
    `name_en`     VARCHAR(150)        NOT NULL,
    `fullName_de` VARCHAR(200)        NOT NULL,
    `fullName_en` VARCHAR(200)        NOT NULL,
    `active`      TINYINT(1) UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `entry` (`code`, `categoryID`),
    INDEX `categoryID` (`categoryID`),
    UNIQUE `code` (`code`),
    INDEX `gridID` (`gridID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_holidays` (
    `id`        INT(11) UNSIGNED    NOT NULL AUTO_INCREMENT,
    `name_de`   VARCHAR(150)        NOT NULL,
    `name_en`   VARCHAR(150)        NOT NULL,
    `startDate` DATE                NOT NULL,
    `endDate`   DATE                NOT NULL,
    `type`      TINYINT(1) UNSIGNED NOT NULL DEFAULT 3
        COMMENT 'The impact of the holiday on the planning process. Possible values: 1 - Automatic, 2 - Manual, 3 - Unplannable',
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_instance_groups` (
    `id`       INT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    `assocID`  INT(20) UNSIGNED NOT NULL COMMENT 'The instance to person association id.',
    `groupID`  INT(11) UNSIGNED NOT NULL,
    `delta`    VARCHAR(10)      NOT NULL DEFAULT '' COMMENT 'The association''s delta status. Possible values: empty, new, removed.',
    `modified` TIMESTAMP                 DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `assocID` (`assocID`),
    INDEX `groupID` (`groupID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

# participants are an extension of users which use signed int
CREATE TABLE IF NOT EXISTS `#__organizer_instance_participants` (
    `id`            INT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    `instanceID`    INT(20) UNSIGNED NOT NULL,
    `participantID` INT(11)          NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `instanceID` (`instanceID`),
    INDEX `participantID` (`participantID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_instance_persons` (
    `id`         INT(20) UNSIGNED    NOT NULL AUTO_INCREMENT,
    `instanceID` INT(20) UNSIGNED    NOT NULL,
    `personID`   INT(11) UNSIGNED    NOT NULL,
    `roleID`     TINYINT(2) UNSIGNED NOT NULL DEFAULT 1,
    `delta`      VARCHAR(10)         NOT NULL DEFAULT ''
        COMMENT 'The association''s delta status. Possible values: empty, new, removed.',
    `modified`   TIMESTAMP                    DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT `entry` UNIQUE (`instanceID`, `personID`),
    INDEX `instanceID` (`instanceID`),
    INDEX `personID` (`personID`),
    INDEX `roleID` (`roleID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_instance_rooms` (
    `id`       INT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    `assocID`  INT(20) UNSIGNED NOT NULL COMMENT 'The instance to person association id.',
    `roomID`   INT(11) UNSIGNED NOT NULL,
    `delta`    VARCHAR(10)      NOT NULL DEFAULT ''
        COMMENT 'The association''s delta status. Possible values: empty, new, removed.',
    `modified` TIMESTAMP                 DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `assocID` (`assocID`),
    INDEX `roomID` (`roomID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_instances` (
    `id`       INT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    `blockID`  INT(11) UNSIGNED NOT NULL,
    `eventID`  INT(11) UNSIGNED NOT NULL,
    `methodID` INT(11) UNSIGNED          DEFAULT NULL,
    `unitID`   INT(11) UNSIGNED NOT NULL,
    `delta`    VARCHAR(10)      NOT NULL DEFAULT '',
    `modified` TIMESTAMP                 DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT `entry` UNIQUE (`eventID`, `blockID`, `unitID`),
    INDEX `blockID` (`blockID`),
    INDEX `eventID` (`eventID`),
    INDEX `methodID` (`methodID`),
    INDEX `unitID` (`unitID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_methods` (
    `id`              INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `code`            VARCHAR(60)  DEFAULT NULL,
    `abbreviation_de` VARCHAR(25)  DEFAULT '',
    `abbreviation_en` VARCHAR(25)  DEFAULT '',
    `name_de`         VARCHAR(150) DEFAULT NULL,
    `name_en`         VARCHAR(150) DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE `code` (`code`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_monitors` (
    `id`              INT(11) UNSIGNED    NOT NULL AUTO_INCREMENT,
    `ip`              VARCHAR(15)         NOT NULL,
    `roomID`          INT(11) UNSIGNED             DEFAULT NULL,
    `useDefaults`     TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `display`         INT(1) UNSIGNED     NOT NULL DEFAULT 1 COMMENT 'the display behaviour of the monitor',
    `scheduleRefresh` INT(3) UNSIGNED     NOT NULL DEFAULT 60 COMMENT 'the amount of seconds before the schedule refreshes',
    `contentRefresh`  INT(3) UNSIGNED     NOT NULL DEFAULT 60 COMMENT 'the amount of time in seconds before the content refreshes',
    `interval`        INT(1) UNSIGNED     NOT NULL DEFAULT 1 COMMENT 'the time interval in minutes between context switches',
    `content`         VARCHAR(256)                 DEFAULT '' COMMENT 'the filename of the resource to the optional resource to be displayed',
    PRIMARY KEY (`id`),
    INDEX `roomID` (`roomID`),
    UNIQUE INDEX `ip` (`ip`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_organizations` (
    `id`              INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `asset_id`        INT(11)      DEFAULT NULL,
    `alias`           VARCHAR(255) DEFAULT '',
    `abbreviation_de` VARCHAR(25)      NOT NULL,
    `abbreviation_en` VARCHAR(25)      NOT NULL,
    `shortName_de`    VARCHAR(50)      NOT NULL,
    `shortName_en`    VARCHAR(50)      NOT NULL,
    `name_de`         VARCHAR(150)     NOT NULL,
    `name_en`         VARCHAR(150)     NOT NULL,
    `fullName_de`     VARCHAR(200)     NOT NULL,
    `fullName_en`     VARCHAR(200)     NOT NULL,
    `contactID`       INT(11)      DEFAULT NULL,
    `contactEmail`    VARCHAR(100) DEFAULT NULL,
    `URL`             VARCHAR(255) DEFAULT '' COMMENT 'The base URL for the organization''s homepage.',
    PRIMARY KEY (`id`),
    UNIQUE INDEX `abbreviation_de` (`abbreviation_de`),
    UNIQUE INDEX `abbreviation_en` (`abbreviation_en`),
    UNIQUE INDEX `shortName_de` (`shortName_de`),
    UNIQUE INDEX `shortName_en` (`shortName_en`),
    UNIQUE INDEX `name_de` (`name_de`),
    UNIQUE INDEX `name_en` (`name_en`),
    UNIQUE INDEX `fullName_de` (`fullName_de`),
    UNIQUE INDEX `fullName_en` (`fullName_en`),
    INDEX `contactID` (`contactID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_participants` (
    `id`        INT(11)             NOT NULL,
    `forename`  VARCHAR(255)        NOT NULL DEFAULT '',
    `surname`   VARCHAR(255)        NOT NULL DEFAULT '',
    `city`      VARCHAR(60)         NOT NULL DEFAULT '',
    `address`   VARCHAR(60)         NOT NULL DEFAULT '',
    `zipCode`   VARCHAR(60)         NOT NULL DEFAULT '',
    `programID` INT(11) UNSIGNED             DEFAULT NULL,
    `notify`    TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    INDEX `programID` (`programID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_persons` (
    `id`       INT(11) UNSIGNED    NOT NULL AUTO_INCREMENT,
    `alias`    VARCHAR(255)                 DEFAULT '',
    `userID`   INT(11)                      DEFAULT NULL,
    `code`     VARCHAR(60)                  DEFAULT NULL,
    `surname`  VARCHAR(255)        NOT NULL,
    `forename` VARCHAR(255)        NOT NULL DEFAULT '',
    `username` VARCHAR(150)                 DEFAULT NULL,
    `title`    VARCHAR(45)         NOT NULL DEFAULT '',
    `active`   TINYINT(1) UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `code` (`code`),
    INDEX `userID` (`userID`),
    UNIQUE INDEX `username` (`username`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_pools` (
    `id`              INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `alias`           VARCHAR(255)     DEFAULT '',
    `organizationID`  INT(11) UNSIGNED DEFAULT NULL,
    `fieldID`         INT(11) UNSIGNED DEFAULT NULL,
    `groupID`         INT(11) UNSIGNED DEFAULT NULL,
    `lsfID`           INT(11) UNSIGNED DEFAULT NULL,
    `abbreviation_de` VARCHAR(25)      DEFAULT '',
    `abbreviation_en` VARCHAR(25)      DEFAULT '',
    `shortName_de`    VARCHAR(50)      DEFAULT '',
    `shortName_en`    VARCHAR(50)      DEFAULT '',
    `fullName_de`     VARCHAR(200)     DEFAULT NULL,
    `fullName_en`     VARCHAR(200)     DEFAULT NULL,
    `description_de`  TEXT,
    `description_en`  TEXT,
    `minCrP`          INT(3) UNSIGNED  DEFAULT 0,
    `maxCrP`          INT(3) UNSIGNED  DEFAULT 0,
    PRIMARY KEY (`id`),
    INDEX `fieldID` (`fieldID`),
    INDEX `groupID` (`groupID`),
    UNIQUE `lsfID` (`lsfID`),
    INDEX `organizationID` (`organizationID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_prerequisites` (
    `id`             INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `subjectID`      INT(11) UNSIGNED NOT NULL,
    `prerequisiteID` INT(11) UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `entry` (`prerequisiteID`, `subjectID`),
    INDEX `prerequisiteID` (`prerequisiteID`),
    INDEX `subjectID` (`subjectID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_programs` (
    `id`             INT(11) UNSIGNED    NOT NULL AUTO_INCREMENT,
    `alias`          VARCHAR(255)                 DEFAULT '',
    `organizationID` INT(11) UNSIGNED    NOT NULL,
    `code`           VARCHAR(60)                  DEFAULT '',
    `degreeID`       INT(11) UNSIGNED    NOT NULL,
    `accredited`     YEAR(4)             NOT NULL,
    `categoryID`     INT(11) UNSIGNED             DEFAULT NULL,
    `frequencyID`    INT(1) UNSIGNED              DEFAULT 3,
    `name_de`        VARCHAR(150)        NOT NULL,
    `name_en`        VARCHAR(150)        NOT NULL,
    `description_de` TEXT,
    `description_en` TEXT,
    `active`         TINYINT(1) UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `entry` (`code`, `degreeID`, `accredited`),
    INDEX `categoryID` (`categoryID`),
    INDEX `degreeID` (`degreeID`),
    INDEX `frequencyID` (`frequencyID`),
    INDEX `organizationID` (`organizationID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_roles` (
    `id`              TINYINT(2) UNSIGNED NOT NULL AUTO_INCREMENT,
    `abbreviation_de` VARCHAR(25)         NOT NULL,
    `abbreviation_en` VARCHAR(25)         NOT NULL,
    `name_de`         VARCHAR(150)        NOT NULL,
    `name_en`         VARCHAR(150)        NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `name_de` (`name_de`),
    UNIQUE INDEX `name_en` (`name_en`),
    UNIQUE INDEX `abbreviation_de` (`abbreviation_de`),
    UNIQUE INDEX `abbreviation_en` (`abbreviation_en`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

INSERT IGNORE INTO `#__organizer_roles` (`id`, `name_de`, `name_en`, `abbreviation_de`, `abbreviation_en`)
VALUES (1, 'Dozent', 'Teacher', 'DOZ', 'TCH'),
       (2, 'Tutor', 'Tutor', 'TUT', 'TUT'),
       (3, 'Aufsicht', 'Supervisor', 'AFS', 'SPR'),
       (4, 'Referent', 'Speaker', 'REF', 'SPK');

CREATE TABLE IF NOT EXISTS `#__organizer_rooms` (
    `id`         INT(11) UNSIGNED    NOT NULL AUTO_INCREMENT,
    `alias`      VARCHAR(255)                 DEFAULT '',
    `buildingID` INT(11) UNSIGNED             DEFAULT NULL,
    `code`       VARCHAR(60)                  DEFAULT NULL,
    `name`       VARCHAR(150)        NOT NULL,
    `roomtypeID` INT(11) UNSIGNED             DEFAULT NULL,
    `capacity`   INT(4) UNSIGNED              DEFAULT NULL,
    `active`     TINYINT(1) UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `code` (`code`),
    INDEX `buildingID` (`buildingID`),
    INDEX `roomtypeID` (`roomtypeID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_roomtypes` (
    `id`             INT(11) UNSIGNED    NOT NULL AUTO_INCREMENT,
    `code`           VARCHAR(60)                  DEFAULT NULL,
    `name_de`        VARCHAR(150)        NOT NULL,
    `name_en`        VARCHAR(150)        NOT NULL,
    `description_de` TEXT                NOT NULL,
    `description_en` TEXT                NOT NULL,
    `minCapacity`    INT(4) UNSIGNED              DEFAULT NULL,
    `maxCapacity`    INT(4) UNSIGNED              DEFAULT NULL,
    `public`         TINYINT(1) UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `code` (`code`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_runs` (
    `id`      INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `name_de` VARCHAR(150)     NOT NULL,
    `name_en` VARCHAR(150)     NOT NULL,
    `termID`  INT(11) UNSIGNED NOT NULL,
    `run`     TEXT             NOT NULL
        COMMENT 'Contains the start date and end dates of individual runs as a JSON string.',
    PRIMARY KEY (`id`),
    INDEX `termID` (`termID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_schedules` (
    `id`             INT(11) UNSIGNED    NOT NULL AUTO_INCREMENT,
    `organizationID` INT(11) UNSIGNED    NOT NULL,
    `termID`         INT(11) UNSIGNED    NOT NULL,
    `userID`         INT(11)                      DEFAULT NULL,
    `creationDate`   DATE                         DEFAULT NULL,
    `creationTime`   TIME                         DEFAULT NULL,
    `schedule`       MEDIUMTEXT,
    `active`         TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    INDEX `organizationID` (`organizationID`),
    INDEX `termID` (`termID`),
    INDEX `userID` (`userID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_subject_events` (
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
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_subject_persons` (
    `id`        INT(11) UNSIGNED    NOT NULL AUTO_INCREMENT,
    `personID`  INT(11) UNSIGNED    NOT NULL,
    `role`      TINYINT(1) UNSIGNED NOT NULL DEFAULT 1
        COMMENT 'The person''s role for the given subject. Roles are not mutually exclusive. Possible values: 1 - coordinates, 2 - teaches.',
    `subjectID` INT(11) UNSIGNED    NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `entry` (`personID`, `role`, `subjectID`),
    INDEX `personID` (`personID`),
    INDEX `subjectID` (`subjectID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_subjects` (
    `id`                          INT(11) UNSIGNED      NOT NULL AUTO_INCREMENT,
    `alias`                       VARCHAR(255)                   DEFAULT '',
    `organizationID`              INT(11) UNSIGNED               DEFAULT NULL,
    `lsfID`                       INT(11) UNSIGNED               DEFAULT NULL,
    `code`                        VARCHAR(60)           NOT NULL DEFAULT '',
    `abbreviation_de`             VARCHAR(25)           NOT NULL DEFAULT '',
    `abbreviation_en`             VARCHAR(25)           NOT NULL DEFAULT '',
    `shortName_de`                VARCHAR(50)           NOT NULL DEFAULT '',
    `shortName_en`                VARCHAR(50)           NOT NULL DEFAULT '',
    `fullName_de`                 VARCHAR(200)          NOT NULL,
    `fullName_en`                 VARCHAR(200)          NOT NULL,
    `description_de`              TEXT,
    `description_en`              TEXT,
    `objective_de`                TEXT,
    `objective_en`                TEXT,
    `content_de`                  TEXT,
    `content_en`                  TEXT,
    `prerequisites_de`            TEXT,
    `prerequisites_en`            TEXT,
    `preliminaryWork_de`          TEXT,
    `preliminaryWork_en`          TEXT,
    `instructionLanguage`         VARCHAR(2)            NOT NULL DEFAULT 'D',
    `literature`                  TEXT,
    `creditpoints`                DOUBLE(4, 1) UNSIGNED NOT NULL DEFAULT 0,
    `expenditure`                 INT(4) UNSIGNED       NOT NULL DEFAULT 0,
    `present`                     INT(4) UNSIGNED       NOT NULL DEFAULT 0,
    `independent`                 INT(4) UNSIGNED       NOT NULL DEFAULT 0,
    `proof_de`                    TEXT,
    `proof_en`                    TEXT,
    `frequencyID`                 INT(1) UNSIGNED                DEFAULT NULL,
    `method_de`                   TEXT,
    `method_en`                   TEXT,
    `fieldID`                     INT(11) UNSIGNED               DEFAULT NULL,
    `sws`                         INT(2) UNSIGNED       NOT NULL DEFAULT 0,
    `aids_de`                     TEXT,
    `aids_en`                     TEXT,
    `evaluation_de`               TEXT,
    `evaluation_en`               TEXT,
    `expertise`                   TINYINT(1) UNSIGNED            DEFAULT NULL,
    `selfCompetence`              TINYINT(1) UNSIGNED            DEFAULT NULL,
    `methodCompetence`            TINYINT(1) UNSIGNED            DEFAULT NULL,
    `socialCompetence`            TINYINT(1) UNSIGNED            DEFAULT NULL,
    `recommendedPrerequisites_de` TEXT,
    `recommendedPrerequisites_en` TEXT,
    `usedFor_de`                  TEXT,
    `usedFor_en`                  TEXT,
    `duration`                    INT(2) UNSIGNED                DEFAULT 1,
    `bonusPoints_de`              TEXT,
    `bonusPoints_en`              TEXT,
    PRIMARY KEY (`id`),
    INDEX `fieldID` (`fieldID`),
    INDEX `frequencyID` (`frequencyID`),
    INDEX `organizationID` (`organizationID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_terms` (
    `id`          INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `code`        VARCHAR(60)      NOT NULL,
    `name_de`     VARCHAR(150) DEFAULT '',
    `name_en`     VARCHAR(150) DEFAULT '',
    `fullName_de` VARCHAR(200) DEFAULT '',
    `fullName_en` VARCHAR(200) DEFAULT '',
    `startDate`   DATE             NOT NULL,
    `endDate`     DATE             NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `entry` (`code`, `startDate`, `endDate`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `#__organizer_units` (
    `id`             INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `organizationID` INT(11) UNSIGNED NOT NULL,
    `termID`         INT(11) UNSIGNED NOT NULL,
    `code`           INT(11) UNSIGNED NOT NULL,
    `courseID`       INT(11) UNSIGNED          DEFAULT NULL,
    `gridID`         INT(11) UNSIGNED          DEFAULT NULL,
    `runID`          INT(11) UNSIGNED          DEFAULT NULL,
    `endDate`        DATE                      DEFAULT NULL,
    `startDate`      DATE                      DEFAULT NULL,
    `comment`        VARCHAR(255)              DEFAULT NULL,
    `delta`          VARCHAR(10)      NOT NULL DEFAULT '' COMMENT 'The unit''s delta status. Possible values: empty, new, removed.',
    `modified`       TIMESTAMP                 DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `entry` (`code`, `organizationID`, `termID`),
    INDEX `code` (`code`),
    INDEX `courseID` (`courseID`),
    INDEX `gridID` (`gridID`),
    INDEX `organizationID` (`organizationID`),
    INDEX `runID` (`runID`),
    INDEX `termID` (`termID`)
)
    ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_bin;

ALTER TABLE `#__organizer_associations`
    ADD CONSTRAINT `association_categoryID_fk` FOREIGN KEY (`categoryID`) REFERENCES `#__organizer_categories` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `association_eventID_fk` FOREIGN KEY (`eventID`) REFERENCES `#__organizer_events` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `association_groupID_fk` FOREIGN KEY (`groupID`) REFERENCES `#__organizer_groups` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `association_organizationID_fk` FOREIGN KEY (`organizationID`) REFERENCES `#__organizer_organizations` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `association_personID_fk` FOREIGN KEY (`personID`) REFERENCES `#__organizer_persons` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `association_roomID_fk` FOREIGN KEY (`roomID`) REFERENCES `#__organizer_rooms` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_buildings`
    ADD CONSTRAINT `building_campusID_fk` FOREIGN KEY (`campusID`) REFERENCES `#__organizer_campuses` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_campuses`
    ADD CONSTRAINT `campus_gridID_fk` FOREIGN KEY (`gridID`) REFERENCES `#__organizer_grids` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    ADD CONSTRAINT `campus_parentID_fk` FOREIGN KEY (`parentID`) REFERENCES `#__organizer_campuses` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_course_participants`
    ADD CONSTRAINT `course_participant_courseID_fk` FOREIGN KEY (`courseID`) REFERENCES `#__organizer_courses` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `course_participant_participantID_fk` FOREIGN KEY (`participantID`) REFERENCES `#__organizer_participants` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_courses`
    ADD CONSTRAINT `course_campusID_fk` FOREIGN KEY (`campusID`) REFERENCES `#__organizer_campuses` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    ADD CONSTRAINT `course_termID_fk` FOREIGN KEY (`termID`) REFERENCES `#__organizer_terms` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_curricula`
    ADD CONSTRAINT `curriculum_parentID_fk` FOREIGN KEY (`parentID`) REFERENCES `#__organizer_curricula` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `curriculum_poolID_fk` FOREIGN KEY (`poolID`) REFERENCES `#__organizer_pools` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `curriculum_programID_fk` FOREIGN KEY (`programID`) REFERENCES `#__organizer_programs` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `curriculum_subjectID_fk` FOREIGN KEY (`subjectID`) REFERENCES `#__organizer_subjects` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_event_coordinators`
    ADD CONSTRAINT `event_coordinator_eventID_fk` FOREIGN KEY (`eventID`) REFERENCES `#__organizer_events` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `event_coordinator_personID_fk` FOREIGN KEY (`personID`) REFERENCES `#__organizer_persons` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_events`
    ADD CONSTRAINT `event_campusID_fk` FOREIGN KEY (`campusID`) REFERENCES `#__organizer_campuses` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    ADD CONSTRAINT `event_organizationID_fk` FOREIGN KEY (`organizationID`) REFERENCES `#__organizer_organizations` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_field_colors`
    ADD CONSTRAINT `field_color_colorID_fk` FOREIGN KEY (`colorID`) REFERENCES `#__organizer_colors` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `field_color_fieldID_fk` FOREIGN KEY (`fieldID`) REFERENCES `#__organizer_fields` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `field_color_organizationID_fk` FOREIGN KEY (`organizationID`) REFERENCES `#__organizer_organizations` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_group_publishing`
    ADD CONSTRAINT `group_publishing_groupID_fk` FOREIGN KEY (`groupID`) REFERENCES `#__organizer_groups` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `group_publishing_termID_fk` FOREIGN KEY (`termID`) REFERENCES `#__organizer_terms` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_groups`
    ADD CONSTRAINT `group_categoryID_fk` FOREIGN KEY (`categoryID`) REFERENCES `#__organizer_categories` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `group_gridID_fk` FOREIGN KEY (`gridID`) REFERENCES `#__organizer_grids` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_instance_groups`
    ADD CONSTRAINT `instance_group_assocID_fk` FOREIGN KEY (`assocID`) REFERENCES `#__organizer_instance_persons` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `instance_group_groupID_fk` FOREIGN KEY (`groupID`) REFERENCES `#__organizer_groups` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_instance_participants`
    ADD CONSTRAINT `instance_participant_instanceID_fk` FOREIGN KEY (`instanceID`) REFERENCES `#__organizer_instances` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `instance_participant_participantID_fk` FOREIGN KEY (`participantID`) REFERENCES `#__organizer_participants` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_instance_persons`
    ADD CONSTRAINT `instance_person_instanceID_fk` FOREIGN KEY (`instanceID`) REFERENCES `#__organizer_instances` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `instance_person_personID_fk` FOREIGN KEY (`personID`) REFERENCES `#__organizer_persons` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `instance_person_roleID_fk` FOREIGN KEY (`roleID`) REFERENCES `#__organizer_roles` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_instance_rooms`
    ADD CONSTRAINT `instance_room_assocID_fk` FOREIGN KEY (`assocID`) REFERENCES `#__organizer_instance_persons` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `instance_room_roomID_fk` FOREIGN KEY (`roomID`) REFERENCES `#__organizer_rooms` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_instances`
    ADD CONSTRAINT `instance_blockID_fk` FOREIGN KEY (`blockID`) REFERENCES `#__organizer_blocks` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `instance_eventID_fk` FOREIGN KEY (`eventID`) REFERENCES `#__organizer_events` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `instance_methodID_fk` FOREIGN KEY (`methodID`) REFERENCES `#__organizer_methods` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    ADD CONSTRAINT `instance_unitID_fk` FOREIGN KEY (`unitID`) REFERENCES `#__organizer_units` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_monitors`
    ADD CONSTRAINT `monitor_roomID_fk` FOREIGN KEY (`roomID`) REFERENCES `#__organizer_rooms` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_organizations`
    ADD CONSTRAINT `organization_contactID_fk` FOREIGN KEY (`contactID`) REFERENCES `#__users` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_participants`
    ADD CONSTRAINT `participant_programID_fk` FOREIGN KEY (`programID`) REFERENCES `#__organizer_programs` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    ADD CONSTRAINT `participant_userID_fk` FOREIGN KEY (`id`) REFERENCES `#__users` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_persons`
    ADD CONSTRAINT `person_userID_fk` FOREIGN KEY (`userID`) REFERENCES `#__users` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_pools`
    ADD CONSTRAINT `pool_fieldID_fk` FOREIGN KEY (`fieldID`) REFERENCES `#__organizer_fields` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    ADD CONSTRAINT `pool_groupID_fk` FOREIGN KEY (`groupID`) REFERENCES `#__organizer_groups` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    ADD CONSTRAINT `pool_organizationID_fk` FOREIGN KEY (`organizationID`) REFERENCES `#__organizer_organizations` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_prerequisites`
    ADD CONSTRAINT `prerequisite_prerequisiteID_fk` FOREIGN KEY (`prerequisiteID`) REFERENCES `#__organizer_curriculum` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `prerequisite_subjectID_fk` FOREIGN KEY (`subjectID`) REFERENCES `#__organizer_curriculum` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_programs`
    ADD CONSTRAINT `program_categoryID_fk` FOREIGN KEY (`categoryID`) REFERENCES `#__organizer_categories` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    ADD CONSTRAINT `program_degreeID_fk` FOREIGN KEY (`degreeID`) REFERENCES `#__organizer_degrees` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    ADD CONSTRAINT `program_frequencyID_fk` FOREIGN KEY (`frequencyID`) REFERENCES `#__organizer_frequencies` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    ADD CONSTRAINT `program_organizationID_fk` FOREIGN KEY (`organizationID`) REFERENCES `#__organizer_organizations` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_rooms`
    ADD CONSTRAINT `room_buildingID_fk` FOREIGN KEY (`buildingID`) REFERENCES `#__organizer_buildings` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    ADD CONSTRAINT `room_roomtypeID_fk` FOREIGN KEY (`roomtypeID`) REFERENCES `#__organizer_roomtypes` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_runs`
    ADD CONSTRAINT `run_termID_fk` FOREIGN KEY (`termID`) REFERENCES `#__organizer_terms` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_schedules`
    ADD CONSTRAINT `schedule_organizationID_fk` FOREIGN KEY (`organizationID`) REFERENCES `#__organizer_organizations` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `schedule_termID_fk` FOREIGN KEY (`termID`) REFERENCES `#__organizer_terms` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `schedule_userID_fk` FOREIGN KEY (`userID`) REFERENCES `#__users` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_subject_events`
    ADD CONSTRAINT `subject_event_eventID_fk` FOREIGN KEY (`eventID`) REFERENCES `#__organizer_events` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `subject_event_subjectID_fk` FOREIGN KEY (`subjectID`) REFERENCES `#__organizer_subjects` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_subject_persons`
    ADD CONSTRAINT `subject_person_personID_fk` FOREIGN KEY (`personID`) REFERENCES `#__organizer_persons` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `subject_person_subjectID_fk` FOREIGN KEY (`subjectID`) REFERENCES `#__organizer_subjects` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_subjects`
    ADD CONSTRAINT `subject_fieldID_fk` FOREIGN KEY (`fieldID`) REFERENCES `#__organizer_fields` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    ADD CONSTRAINT `subject_frequencyID_fk` FOREIGN KEY (`frequencyID`) REFERENCES `#__organizer_frequencies` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    ADD CONSTRAINT `subject_organizationID_fk` FOREIGN KEY (`organizationID`) REFERENCES `#__organizer_organizations` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE;

ALTER TABLE `#__organizer_units`
    ADD CONSTRAINT `unit_courseID_fk` FOREIGN KEY (`courseID`) REFERENCES `#__organizer_courses` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    ADD CONSTRAINT `unit_gridID_fk` FOREIGN KEY (`gridID`) REFERENCES `#__organizer_grids` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    ADD CONSTRAINT `unit_organizationID_fk` FOREIGN KEY (`organizationID`) REFERENCES `#__organizer_organizations` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT `unit_runID_fk` FOREIGN KEY (`runID`) REFERENCES `#__organizer_runs` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    ADD CONSTRAINT `unit_termID_fk` FOREIGN KEY (`termID`) REFERENCES `#__organizer_terms` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;
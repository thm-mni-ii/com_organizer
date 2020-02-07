<?php
/**
 * @package     Organizer
 * @extension   com_organizer
 * @author      James Antrim, <james.antrim@nm.thm.de>
 * @copyright   2020 TH Mittelhessen
 * @license     GNU GPL v.3
 * @link        www.thm.de
 */

namespace Organizer\Tables;

/**
 * Models the organizer_groups table.
 */
class Groups extends BaseTable
{
	use Addressable;

	/**
	 * A flag which displays whether the resource is currently active.
	 * TINYINT(1) UNSIGNED NOT NULL DEFAULT 1
	 *
	 * @var bool
	 */
	public $active;

	/**
	 * The id of the category entry referenced.
	 * INT(11) UNSIGNED DEFAULT NULL
	 *
	 * @var int
	 */
	public $categoryID;

	/**
	 * An abbreviated nomenclature for the resource. Currently corresponding to the identifier in Untis scheduling
	 * software.
	 * VARCHAR(60) DEFAULT NULL
	 *
	 * @var string
	 */
	public $code;

	/**
	 * The id of the field entry referenced.
	 * INT(11) UNSIGNED DEFAULT NULL
	 *
	 * @var int
	 */
	public $fieldID;

	/**
	 * The resource's full name.
	 * VARCHAR(100) NOT NULL
	 *
	 * @var string
	 */
	public $fullName;

	/**
	 * The id of the grid entry referenced.
	 * INT(11) UNSIGNED DEFAULT 1
	 *
	 * @var int
	 */
	public $gridID;

	/**
	 * The resource's name.
	 * VARCHAR(100) NOT NULL
	 *
	 * @var string
	 */
	public $name;

	/**
	 * Declares the associated table
	 *
	 * @param   \JDatabaseDriver &$dbo  A database connector object
	 */
	public function __construct(&$dbo = null)
	{
		parent::__construct('#__organizer_groups', 'id', $dbo);
	}

	/**
	 * Set the table column names which are allowed to be null
	 *
	 * @return boolean  true
	 */
	public function check()
	{
		if (empty($this->fieldID))
		{
			$this->fieldID = null;
		}

		return true;
	}
}
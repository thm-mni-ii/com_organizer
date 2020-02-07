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

use JDatabaseDriver;

/**
 * Models the organizer_curricula table.
 */
class Curricula extends BaseTable
{
	/**
	 * The depth of this element in the mapping hierarchy.
	 * INT(11) UNSIGNED DEFAULT NULL
	 *
	 * @var int
	 */
	public $level;

	/**
	 * The left most value of this resource as viewed on a numbered line.
	 * INT(11) UNSIGNED DEFAULT NULL
	 *
	 * @var int
	 */
	public $lft;

	/**
	 * The order of this element among its hierarchical siblings.
	 * INT(11) UNSIGNED DEFAULT NULL
	 *
	 * @var int
	 */
	public $ordering;

	/**
	 * The id of the mappings entry referenced as parent.
	 * INT(11) UNSIGNED DEFAULT NULL
	 *
	 * @var int
	 */
	public $parentID;

	/**
	 * The id of the pool entry referenced.
	 * INT(11) UNSIGNED DEFAULT NULL
	 *
	 * @var int
	 */
	public $poolID;

	/**
	 * The id of the program entry referenced.
	 * INT(11) UNSIGNED DEFAULT NULL
	 *
	 * @var int
	 */
	public $programID;

	/**
	 * The right most value of this resource as viewed on a numbered line.
	 * INT(11) UNSIGNED DEFAULT NULL
	 *
	 * @var int
	 */
	public $rgt;

	/**
	 * The id of the subject entry referenced.
	 * INT(11) UNSIGNED DEFAULT NULL
	 *
	 * @var int
	 */
	public $subjectID;

	/**
	 * Declares the associated table
	 *
	 * @param   JDatabaseDriver &$dbo  A database connector object
	 */
	public function __construct(&$dbo = null)
	{
		parent::__construct('#__organizer_mappings', 'id', $dbo);
	}

	/**
	 * Set the table column names which are allowed to be null
	 *
	 * @return boolean  true
	 */
	public function check()
	{
		// All three fields can recieve data from at least two systems.
		$atLeastOne = false;
		$keyColumns = ['programID', 'poolID', 'subjectID'];
		foreach ($keyColumns as $keyColumn)
		{
			if (!strlen($this->$keyColumn))
			{
				$this->$keyColumn = null;
				continue;
			}

			$atLeastOne = true;
		}

		return $atLeastOne;
	}
}

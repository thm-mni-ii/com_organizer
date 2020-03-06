<?php
/**
 * @package     Organizer
 * @extension   com_organizer
 * @author      James Antrim, <james.antrim@nm.thm.de>
 * @copyright   2020 TH Mittelhessen
 * @license     GNU GPL v.3
 * @link        www.thm.de
 */

namespace Organizer\Models;

use JDatabaseQuery;
use Organizer\Helpers;

/**
 * Class retrieves information for a filtered set of room types.
 */
class Roomtypes extends ListModel
{
	/**
	 * Method to get a list of resources from the database.
	 *
	 * @return JDatabaseQuery
	 */
	protected function getListQuery()
	{
		$tag = Helpers\Languages::getTag();

		$linkParts = ["'index.php?option=com_organizer&view=roomtype_edit&id='", 't.id'];
		$query     = $this->_db->getQuery(true);
		$query->select("DISTINCT t.id, t.name_$tag AS name, t.minCapacity, t.maxCapacity, t.code")
			->select($query->concatenate($linkParts, '') . ' AS link')
			->select('count(r.roomtypeID) AS roomCount')
			->from('#__organizer_roomtypes AS t')
			->leftJoin('#__organizer_rooms AS r ON r.roomtypeID = t.id')
			->group('t.id');

		$this->setSearchFilter($query, ['code', 'name_de', 'name_en', 'minCapacity', 'maxCapacity']);
		$this->setOrdering($query);

		return $query;
	}
}
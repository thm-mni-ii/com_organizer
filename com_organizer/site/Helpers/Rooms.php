<?php
/**
 * @package     Organizer
 * @extension   com_organizer
 * @author      James Antrim, <james.antrim@nm.thm.de>
 * @copyright   2020 TH Mittelhessen
 * @license     GNU GPL v.3
 * @link        www.thm.de
 */

namespace Organizer\Helpers;

use Organizer\Adapters;
use Organizer\Tables;

/**
 * Class provides general functions for retrieving room data.
 */
class Rooms extends ResourceHelper implements Selectable
{
	const ALL = -1;

	use Filtered;

	/**
	 * Resolves a text to a room id.
	 *
	 * @param   string  $room  the name of the room
	 *
	 * @return int the id of the entry
	 */
	public static function getID($room)
	{
		$table = new Tables\Rooms();

		if ($table->load(['alias' => $room]))
		{
			return $table->id;
		}

		if ($table->load(['name' => $room]))
		{
			return $table->id;
		}

		return 0;
	}

	/**
	 * Retrieves a list of resources in the form of name => id.
	 *
	 * @return array the resources, or empty
	 */
	public static function getOptions()
	{
		$options = [];
		foreach (self::getResources() as $room)
		{
			if ($room['active'])
			{
				$options[] = HTML::_('select.option', $room['id'], $room['name']);
			}
		}

		return $options;
	}

	/**
	 * Retrieves the ids for filtered rooms used in events.
	 *
	 * @return array the rooms used in actual events which meet the filter criteria
	 */
	public static function getPlannedRooms()
	{
		$query = Adapters\Database::getQuery(true);
		$query->select('r.id, r.name, r.roomtypeID')
			->from('#__organizer_rooms AS r')
			->innerJoin('#__organizer_instance_rooms AS ir ON ir.roomID = r.id')
			->order('r.name');

		if ($organizationID = Input::getFilterID('organization'))
		{
			$query->innerJoin('#__organizer_instance_groups AS ig ON ig.assocID = ir.assocID')
				->innerJoin('#__organizer_groups AS g ON g.id = ig.groupID')
				->innerJoin('#__organizer_associations AS a ON a.categoryID = g.categoryID')
				->where("a.organizationID = $organizationID");

			if ($selectedCategory = Input::getFilterID('category'))
			{
				$query->where("g.categoryID  = $selectedCategory");
			}
		}

		Adapters\Database::setQuery($query);

		if (!$results = Adapters\Database::loadAssocList())
		{
			return [];
		}

		$plannedRooms = [];
		foreach ($results as $result)
		{
			$plannedRooms[$result['name']] = ['id' => $result['id'], 'roomtypeID' => $result['roomtypeID']];
		}

		return $plannedRooms;
	}

	/**
	 * Retrieves all room entries which match the given filter criteria. Ordered by their display names.
	 *
	 * @return array the rooms matching the filter criteria or empty if none were found
	 */
	public static function getResources()
	{
		$query = Adapters\Database::getQuery(true);
		$query->select("DISTINCT r.id, r.*")
			->from('#__organizer_rooms AS r')
			->innerJoin('#__organizer_roomtypes AS rt ON rt.id = r.roomtypeID');

		self::addResourceFilter($query, 'building', 'b1', 'r');

		// TODO Remove roomTypeIDs on completion of migration.
		$roomtypeID  = Input::getInt('roomtypeID', Input::getInt('roomTypeIDs', self::ALL));
		$roomtypeIDs = $roomtypeID ? [$roomtypeID] : Input::getFilterIDs('roomtype');

		if (!in_array(self::ALL, $roomtypeIDs))
		{
			$query->where("rt.id IN (" . implode(',', $roomtypeIDs) . ")");
		}

		$active = Input::getInt('active', 1);

		if ($active !== self::ALL)
		{
			$query->where("r.active = $active");
		}

		$suppress = Input::getInt('suppress', 0);

		if ($suppress !== self::ALL)
		{
			$query->where("rt.suppress = $suppress");
		}

		// This join is used specifically to filter campuses independent of buildings.
		$query->leftJoin('#__organizer_buildings AS b2 ON b2.id = r.buildingID');
		self::addCampusFilter($query, 'b2');

		$query->order('name');
		Adapters\Database::setQuery($query);

		return Adapters\Database::loadAssocList();
	}
}

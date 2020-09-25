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

use Exception;
use Organizer\Helpers;

/**
 * Class provides methods for merging resources. Resource specific tasks are implemented in the extending classes.
 */
abstract class MergeModel extends BaseModel
{
	/**
	 * @var string the column name in the organization resources table
	 */
	protected $association;

	/**
	 * @var array the preprocessed form data
	 */
	protected $data = [];

	/**
	 * The ids selected by the user
	 *
	 * @var array
	 */
	protected $selected = [];

	/**
	 * Attempts to delete resource entries
	 *
	 * @return boolean  true on success, otherwise false
	 */
	public function delete()
	{
		if (!$this->selected = Helpers\Input::getSelectedIDs())
		{
			return false;
		}

		$this->authorize();

		foreach ($this->selected as $resourceID)
		{
			$table = $this->getTable();

			if ($table->load($resourceID))
			{
				$table->delete($resourceID);
			}
		}

		return true;
	}

	/**
	 * Get the ids of the resources associated over an association table.
	 *
	 * @param   string  $assocColumn  the name of the column which has the associated ids
	 * @param   string  $assocTable   the unique part of the association table name
	 *
	 * @return array the associated ids
	 */
	protected function getAssociatedResourceIDs($assocColumn, $assocTable)
	{
		$mergeIDs = implode(', ', $this->selected);
		$query    = $this->_db->getQuery(true);
		$query->select("DISTINCT $assocColumn")
			->from("#__organizer_$assocTable")
			->where("$this->fkColumn IN ($mergeIDs)");
		$this->_db->setQuery($query);

		return Helpers\OrganizerHelper::executeQuery('loadColumn', []);
	}

	/**
	 * Retrieves the ids of all saved schedules
	 *
	 * @return mixed  array on success, otherwise null
	 */
	protected function getSchedulesIDs()
	{
		$query = $this->_db->getQuery(true);
		$query->select('id');
		$query->from('#__organizer_schedules');
		$this->_db->setQuery($query);

		return Helpers\OrganizerHelper::executeQuery('loadColumn', []);
	}

	/**
	 * Merges resource entries and cleans association tables.
	 *
	 * @return boolean  true on success, otherwise false
	 */
	public function merge()
	{
		$this->selected = Helpers\Input::getSelectedIDs();
		sort($this->selected);

		if (!Helpers\Can::administrate())
		{
			Helpers\OrganizerHelper::error(403);
		}

		// Associations have to be updated before entity references are deleted by foreign keys
		if (!$this->updateAssociations())
		{
			return false;
		}

		$data          = empty($this->data) ? Helpers\Input::getFormItems()->toArray() : $this->data;
		$deprecatedIDs = $this->selected;
		$data['id']    = array_shift($deprecatedIDs);
		$table         = $this->getTable();

		// Remove deprecated entries
		foreach ($deprecatedIDs as $deprecated)
		{
			if (!$table->delete($deprecated))
			{
				return false;
			}
		}

		// Save the merged values of the current entry
		if (!$table->save($data))
		{
			return false;
		}

		if ($this instanceof ScheduleResource and !$this->updateSchedules())
		{
			return false;
		}

		// Any further processing should not iterate over deprecated ids.
		$this->selected = [$data['id']];

		return true;
	}

	/**
	 * Attempts to save the resource.
	 *
	 * @param   array  $data  the data from the form
	 *
	 * @return bool true on success, otherwise false
	 */
	public function save($data = [])
	{
		$this->authorize();

		$this->data = empty($data) ? Helpers\Input::getFormItems()->toArray() : $data;

		try
		{
			$table = $this->getTable();
		}
		catch (Exception $exception)
		{
			Helpers\OrganizerHelper::message($exception->getMessage());

			return false;
		}

		// Merge associations and external data first

		// Set id for new rewrite for existing.
		/*$this->data['id'] = $table->id;

		if (!empty($this->association) and !$this->updateOrganizations())
		{
			return false;
		}*/

		return $table->save($this->data) ? $table->id : false;
	}

	/**
	 * Updates an association where the associated resource itself has a fk reference to the resource being merged.
	 *
	 * @param   string  $tableSuffix  the unique part of the table name
	 *
	 * @return boolean  true on success, otherwise false
	 */
	/*protected function updateDirectAssociation($tableSuffix)
	{
		$updateIDs = $this->selected;
		$mergeID   = array_shift($updateIDs);
		$updateIDs = "'" . implode("', '", $updateIDs) . "'";

		$query = $this->_db->getQuery(true);
		$query->update("#__organizer_$tableSuffix");
		$query->set("{$this->fkColumn} = $mergeID");
		$query->where("{$this->fkColumn} IN ( $updateIDs )");
		$this->_db->setQuery($query);

		return (bool) Helpers\OrganizerHelper::executeQuery('execute', false);
	}*/

	/**
	 * Updates the resource dependent associations
	 *
	 * @return boolean  true on success, otherwise false
	 */
	/*abstract protected function updateAssociations();*/

	/**
	 * Updates the associated organizations for a resource
	 *
	 * @return bool true on success, otherwise false
	 */
	/*private function updateOrganizations()
	{
		$existingQuery = $this->_db->getQuery(true);
		$existingQuery->select('DISTINCT organizationID');
		$existingQuery->from('#__organizer_associations');
		$existingQuery->where("{$this->association} = {$this->data['id']}");
		$this->_db->setQuery($existingQuery);
		$existing = Helpers\OrganizerHelper::executeQuery('loadColumn', []);

		if ($deprecated = array_diff($existing, $this->data['organizationID']))
		{
			$deletionQuery = $this->_db->getQuery(true);
			$deletionQuery->delete('#__organizer_associations');
			$deletionQuery->where("{$this->association} = {$this->data['id']}");
			$deletionQuery->where("organizationID IN ('" . implode("','", $deprecated) . "')");
			$this->_db->setQuery($deletionQuery);

			if (!Helpers\OrganizerHelper::executeQuery('execute', false))
			{
				return false;
			}
		}

		$new = array_diff($this->data['organizationID'], $existing);

		if (!empty($new))
		{
			$insertQuery = $this->_db->getQuery(true);
			$insertQuery->insert('#__organizer_associations');
			$insertQuery->columns("organizationID, {$this->association}");

			foreach ($new as $newID)
			{
				$insertQuery->values("'$newID', '{$this->data['id']}'");
				$this->_db->setQuery($insertQuery);

				if (!Helpers\OrganizerHelper::executeQuery('execute', false))
				{
					return false;
				}
			}
		}

		return true;
	}*/

	/**
	 * Updates organization resource associations
	 *
	 * @return boolean  true on success, otherwise false
	 */
	/*protected function updateDRAssociation()
	{
		$relevantIDs = "'" . implode("', '", $this->selected) . "'";

		$selectQuery = $this->_db->getQuery(true);
		$selectQuery->select('DISTINCT organizationID');
		$selectQuery->from('#__organizer_associations');
		$selectQuery->where("{$this->association} IN ( $relevantIDs )");
		$this->_db->setQuery($selectQuery);
		$organizationIDs = Helpers\OrganizerHelper::executeQuery('loadColumn', []);

		if (empty($organizationIDs))
		{
			return true;
		}

		$deleteQuery = $this->_db->getQuery(true);
		$deleteQuery->delete('#__organizer_associations')
			->where("{$this->fkColumn} IN ( $relevantIDs )");
		$this->_db->setQuery($deleteQuery);

		if (!Helpers\OrganizerHelper::executeQuery('execute', false))
		{
			return false;
		}

		$mergeID     = reset($this->selected);
		$insertQuery = $this->_db->getQuery(true);
		$insertQuery->insert('#__organizer_associations');
		$insertQuery->columns("organizationID, {$this->fkColumn}");

		foreach ($organizationIDs as $organizationID)
		{
			$insertQuery->values("'$organizationID', $mergeID");
		}

		$this->_db->setQuery($insertQuery);

		return (bool) Helpers\OrganizerHelper::executeQuery('execute', false);
	}*/

	/**
	 * Updates room data and lesson associations in active schedules
	 *
	 * @return bool  true on success, otherwise false
	 */
	/*private function updateSchedules()
	{
		$scheduleIDs = $this->getSchedulesIDs();
		if (empty($scheduleIDs))
		{
			return true;
		}

		foreach ($scheduleIDs as $scheduleID)
		{
			$scheduleTable = new Tables\Schedules;

			if (!$scheduleTable->load($scheduleID))
			{
				continue;
			}

			if ($this->updateSchedule($scheduleTable) and !$scheduleTable->store())
			{
				return false;
			}
		}

		return true;
	}*/
}
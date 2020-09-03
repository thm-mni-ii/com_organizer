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
use Joomla\CMS\Factory;
use Joomla\CMS\MVC\Model\AdminModel;
use Organizer\Helpers;
use Organizer\Tables;

/**
 * Class loads a form for editing participant data.
 */
class ParticipantEdit extends EditModel
{
	/**
	 * Checks for user authorization to access the view
	 *
	 * @return bool  true if the user can access the view, otherwise false
	 */
	protected function allow()
	{
		return Helpers\Can::edit('participant', $this->item->id);
	}

	/**
	 * Method to get a single record.
	 *
	 * @param   integer  $participantID  The id of the primary key.
	 *
	 * @return mixed    Object on success, false on failure.
	 * @throws Exception => unauthorized access
	 */
	public function getItem($participantID = null)
	{
		if (!$userID = Factory::getUser()->id)
		{
			throw new Exception(Helpers\Languages::_('ORGANIZER_401'), 401);
		}

		$participantID = empty($participantID) ? Helpers\Input::getSelectedID($userID) : $participantID;

		// Prevents duplicate execution from getForm and getItem
		if (isset($this->item->id) and ($this->item->id === $participantID))
		{
			return $this->item;
		}

		$this->item           = AdminModel::getItem($participantID);
		$this->item->referrer = Helpers\Input::getInput()->server->getString('HTTP_REFERER');
		$this->item->id       = $this->item->id ? $this->item->id : $participantID;

		if (!$this->allow())
		{
			throw new Exception(Helpers\Languages::_('ORGANIZER_403'), 401);
		}

		return $this->item;
	}

	/**
	 * Method to get a table object, load it if necessary.
	 *
	 * @param   string  $name     The table name. Optional.
	 * @param   string  $prefix   The class prefix. Optional.
	 * @param   array   $options  Configuration array for model. Optional.
	 *
	 * @return Tables\Participants A Table object
	 *
	 * @SuppressWarnings(PHPMD.UnusedFormalParameter)
	 */
	public function getTable($name = '', $prefix = '', $options = [])
	{
		return new Tables\Participants;
	}
}
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

use Organizer\Adapters\Database;
use Organizer\Helpers;

/**
 * Class calculates lesson statistics and loads them into the view context.
 */
class LessonStatistics extends FormModel
{
	public $columns = [];

	private $tag = 'de';

	public $lessons = [];

	private $query = null;

	public $rows = [];

	public $total = [];

	public function __construct(array $config = [])
	{
		parent::__construct($config);

		$this->tag = Helpers\Languages::getTag();

		$this->populateState();
		$categoryID     = $this->state->get('categoryID');
		$organizationID = $this->state->get('organizationID');
		$periodID       = $this->state->get('termID');

		$this->query = Database::getQuery();
		$this->setBaseQuery();

		if (empty($periodID))
		{
			$this->rows = $this->getTerms();
		}
		else
		{
			$this->rows = $this->getMethods();
		}

		if (empty($organizationID) and empty($categoryID))
		{
			$this->columns = $this->getOrganizations();
		}
		elseif (empty($categoryID))
		{
			$this->columns = $this->getCategories();
		}
		else
		{
			$this->columns = $this->getGroups();
		}

		$this->setLessonCounts();
	}

	/**
	 * Adds an organization restriction to the query as appropriate.
	 *
	 * @return void
	 */
	private function addOrganizationRestriction()
	{
		$organizationID = $this->state->get('organizationID');
		if (!empty($organizationID))
		{
			$this->query->where("l.organizationID = '$organizationID'");
		}
	}

	/**
	 * Adds a term restriction to the query as appropriate.
	 *
	 * @return void
	 */
	private function addPeriodRestriction()
	{
		$periodID = $this->state->get('termID');
		if (!empty($periodID))
		{
			$this->query->where("l.termID = '$periodID'");
		}
	}

	/**
	 * Adds a category restriction to the query as appropriate.
	 *
	 * @return void
	 */
	private function addCategoryRestriction()
	{
		$categoryID = $this->state->get('categoryID');
		if (!empty($categoryID))
		{
			$this->query->where("cat.id = '$categoryID'");
		}
	}

	/**
	 * Gets an array of event categories.
	 *
	 * @return array the terms
	 */
	private function getCategories()
	{
		$this->resetAdaptiveClauses();
		$this->query->select('DISTINCT cat.id, cat.name')
			->where("l.delta != 'removed'")
			->order('cat.name');

		$this->addOrganizationRestriction();
		$this->addPeriodRestriction();

		Database::setQuery($this->query);

		if (!$categories = Database::loadAssocList('id'))
		{
			return [];
		}

		foreach ($categories as &$category)
		{
			$category['total'] = [];
		}

		return $categories;
	}

	/**
	 * Gets an array of organizations.
	 *
	 * @return array the organizations.
	 */
	private function getOrganizations()
	{
		$this->resetAdaptiveClauses();
		$this->query->select("DISTINCT o.id, o.shortName_$this->tag AS name")
			->where("l.delta != 'removed'")
			->order("o.shortName_$this->tag");

		$this->addPeriodRestriction();

		Database::setQuery($this->query);

		if (!$organizations = Database::loadAssocList('id'))
		{
			return [];
		}

		foreach ($organizations as &$organization)
		{
			$organization['total'] = [];
		}

		return $organizations;
	}

	/**
	 * Method to get the form
	 *
	 * @param   array  $data      Data         (default: array)
	 * @param   bool   $loadData  Load data  (default: true)
	 *
	 * @return mixed  \JForm object on success, False on error.
	 *
	 * @SuppressWarnings(PHPMD.UnusedFormalParameter)
	 */
	public function getForm($data = [], $loadData = true)
	{
		$form = $this->loadForm(
			'com_organizer.lesson_statistics',
			'lesson_statistics',
			['control' => 'jform', 'load_data' => $loadData]
		);

		return !empty($form) ? $form : false;
	}

	/**
	 * Gets an array of groups.
	 *
	 * @return array the groups
	 */
	private function getGroups()
	{
		$this->resetAdaptiveClauses();
		$this->query->select('DISTINCT group.id, group.name')
			->where("l.delta != 'removed'")
			->order('group.name');

		$this->addOrganizationRestriction();
		$this->addPeriodRestriction();
		$this->addCategoryRestriction();

		Database::setQuery($this->query);

		if (!$pools = Database::loadAssocList('id'))
		{
			return [];
		}

		foreach ($pools as &$pool)
		{
			$pool['total'] = [];
		}

		return $pools;
	}

	/**
	 * Gets an array of methods.
	 *
	 * @return array the methods
	 */
	private function getMethods()
	{
		$this->resetAdaptiveClauses();
		$this->query->select("DISTINCT m.id, m.name_$this->tag AS name")
			->where("l.delta != 'removed'")
			->order('name');

		$this->addOrganizationRestriction();
		$this->addPeriodRestriction();
		$this->addCategoryRestriction();

		Database::setQuery($this->query);

		if (!$methods = Database::loadAssocList('id'))
		{
			return [];
		}

		foreach ($methods as &$method)
		{
			if (empty($method['name']))
			{
				$method['name'] = Helpers\Languages::_('ORGANIZER_NONE_GIVEN');
			}
			$method['total'] = [];
		}

		return $methods;
	}

	/**
	 * Gets an array of terms.
	 *
	 * @return array the terms
	 */
	private function getTerms()
	{
		$this->resetAdaptiveClauses();
		$this->query->select('DISTINCT term.*')
			->where('term.startDate <= CURDATE()')
			->where("l.delta != 'removed'")
			->order('term.startDate DESC');

		$this->addOrganizationRestriction();
		$this->addCategoryRestriction();

		Database::setQuery($this->query);

		if ($terms = Database::loadAssocList('id'))
		{
			return [];
		}

		foreach ($terms as &$term)
		{
			$term['total'] = [];
		}

		return $terms;
	}

	/**
	 * Method to auto-populate the model state.
	 *
	 * @return void
	 */
	protected function populateState()
	{
		parent::populateState();

		$categoryID     = 0;
		$organizationID = 0;
		$termID         = Helpers\Terms::getCurrentID();

		if (Helpers\Input::getFormItems()->count())
		{
			$categoryID     = Helpers\Input::getInt('categoryID');
			$organizationID = Helpers\Input::getInt('organizationID');
			$termID         = Helpers\Input::getInt('termID', $termID);
		}

		$this->setState('categoryID', $categoryID);
		$this->setState('organizationID', $organizationID);
		$this->setState('termID', $termID);
	}

	/**
	 * Resets the query clauses which can vary.
	 *
	 * @return void modifies the model's query
	 */
	private function resetAdaptiveClauses()
	{
		$this->query->clear('select')
			->clear('where')
			->clear('order');
	}

	/**
	 * Sets the core clauses for lesson statistics queries.
	 *
	 * @return void modifies the model's query
	 */
	private function setBaseQuery()
	{
		$this->query->from('#__organizer_lessons AS l')
			->innerJoin('#__organizer_terms AS term ON term.id = l.termID')
			->innerJoin('#__organizer_organizations AS o ON o.id = l.organizationID')
			->innerJoin('#__organizer_lesson_courses AS lcrs ON lcrs.lessonID = l.id')
			->innerJoin('#__organizer_lesson_groups AS lg ON lg.lessonCourseID = lcrs.id')
			->innerJoin('#__organizer_groups AS group ON group.id = lg.groupID')
			->innerJoin('#__organizer_categories AS cat ON cat.id = group.categoryID')
			->leftJoin('#__organizer_methods AS m ON m.id = l.methodID');
	}

	/**
	 * Creates an array of arrays with total values. Array[$rowID][$columnID] = $total.
	 *
	 * @returns void sets the model property $lessons
	 */
	private function setLessonCounts()
	{
		$categoryID     = $this->state->get('categoryID');
		$organizationID = $this->state->get('organizationID');
		$termID         = $this->state->get('termID');
		$lessonCounts   = [];
		foreach (array_keys($this->rows) as $rowID)
		{
			$lessons[$rowID] = [];
			foreach (array_keys($this->columns) as $columnID)
			{
				$this->resetAdaptiveClauses();
				$this->query->select('DISTINCT l.id')
					->where("l.delta != 'removed'");

				// Define column column
				if (empty($organizationID))
				{
					$column = empty($categoryID) ? 'o' : 'group';
				}
				else
				{
					$this->query->where("l.organizationID = '$organizationID'");
					$column = empty($categoryID) ? 'cat' : 'group';
				}
				$this->query->where("$column.id = '$columnID'");

				// Define row column
				if (empty($termID))
				{
					$this->query->where("term.id = '$rowID'");
				}
				else
				{
					$this->query->where("term.id = '$termID'");
					$clause = empty($rowID) ? 'm.id IS NULL' : "m.id = '$rowID'";
					$this->query->where($clause);
				}

				Database::setQuery($this->query);
				$lessons = Database::loadIntColumn();

				$lessonCounts[$rowID][$columnID] = count($lessons);

				// Eliminates inflated values for lessons associated with more than one column/row
				$totalLessons                      = array_merge($this->total, $lessons);
				$this->total                       = array_unique($totalLessons);
				$this->columns[$columnID]['total'] = array_unique(array_merge(
					$this->columns[$columnID]['total'],
					$lessons
				));
				$this->rows[$rowID]['total']       = array_unique(array_merge($this->rows[$rowID]['total'], $lessons));
			}
		}

		foreach ($this->columns as $columnID => $column)
		{
			if (empty($column['total']))
			{
				unset($this->columns[$columnID]);
			}
			else
			{
				$this->columns[$columnID]['total'] = count($column['total']);
			}
		}

		foreach ($this->rows as $rowID => $row)
		{
			if (empty($row['total']))
			{
				unset($this->rows[$rowID]);
			}
			else
			{
				$this->rows[$rowID]['total'] = count($row['total']);
			}
		}

		$this->total = count($this->total);

		$this->lessons = $lessonCounts;
	}
}

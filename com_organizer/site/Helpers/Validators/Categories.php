<?php
/**
 * @package     Organizer
 * @extension   com_organizer
 * @author      James Antrim, <james.antrim@nm.thm.de>
 * @copyright   2020 TH Mittelhessen
 * @license     GNU GPL v.3
 * @link        www.thm.de
 */

namespace Organizer\Helpers\Validators;

use Exception;
use Organizer\Helpers;
use Organizer\Tables;
use SimpleXMLElement;
use stdClass;

/**
 * Provides general functions for campus access checks, data retrieval and display.
 */
class Categories extends Helpers\ResourceHelper implements UntisXMLValidator
{
	/**
	 * Determines whether the data conveyed in the untisID is plausible for finding a real program.
	 *
	 * @param   string  $untisID  the id used in untis for this program
	 *
	 * @return array empty if the id is implausible
	 */
	private static function parseProgramData($untisID)
	{
		$pieces = explode('.', $untisID);
		if (count($pieces) !== 3)
		{
			return [];
		}

		// Two uppercase letter code for the degree. First letter is B (Bachelor) or M (Master)
		$implausibleDegree = (!ctype_upper($pieces[1]) or !preg_match('/^[B|M]{1}[A-Z]{1,2}$/', $pieces[1]));
		if ($implausibleDegree)
		{
			return [];
		}

		// Some degree program 'subject' identifiers have a number
		$plausibleCode = preg_match('/^[A-Z]+[0-9]*$/', $pieces[0]);

		// Degrees are their own managed resource
		$degrees  = new Tables\Degrees;
		$degreeID = $degrees->load(['code' => $pieces[1]]) ? $degrees->id : null;

		// Should be year of accreditation, but ITS likes to pick random years
		$plausibleVersion = (ctype_digit($pieces[2]) and preg_match('/^[2]{1}[0-9]{3}$/', $pieces[2]));

		return ($plausibleCode and $degreeID and $plausibleVersion) ?
			['code' => $pieces[0], 'degreeID' => $degreeID, 'accredited' => $pieces[2]] : [];
	}

	/**
	 * Retrieves the resource id using the Untis ID. Creates the resource id if unavailable.
	 *
	 * @param   object  $model  the model for the schedule being validated
	 * @param   string  $code   the id of the resource in Untis
	 *
	 * @return void modifies the model, setting the id property of the resource
	 */
	public static function setID($model, $code)
	{
		$category     = $model->categories->$code;
		$exists       = false;
		$loadCriteria = [['code' => $code], ['name_de' => $category->name_de]];
		$table        = new Tables\Categories;

		foreach ($loadCriteria as $criterion)
		{
			if ($exists = $table->load($criterion))
			{
				$altered = false;

				foreach ($category as $key => $value)
				{
					if (property_exists($table, $key) and empty($table->$key) and !empty($value))
					{
						$table->set($key, $value);
						$altered = true;
					}
				}

				if ($altered)
				{
					$table->store();
				}

				break;
			}
		}

		if (!$exists)
		{
			$table->save($category);
		}

		$category->id = $table->id;

		return;
	}

	/**
	 * Checks whether XML node has the expected structure and required information.
	 *
	 * @param   object            $model  the model for the schedule being validated
	 * @param   SimpleXMLElement  $node   the node being validated
	 *
	 * @return void
	 * @throws Exception => invalid request, unauthorized access
	 */
	public static function validate($model, $node)
	{
		$code = str_replace('DP_', '', trim((string) $node[0]['id']));

		$name = (string) $node->longname;
		if (!isset($name))
		{
			$model->errors[] = sprintf(Helpers\Languages::_('ORGANIZER_CATEGORY_NAME_MISSING'), $code);

			return;
		}

		$category          = new stdClass;
		$category->name_de = $name;
		$category->name_en = $name;
		$category->code    = $code;

		$model->categories->$code = $category;
		self::setID($model, $code);
		Helpers\Organizations::setResource($category->id, 'categoryID');

		if ($programData = self::parseProgramData($code))
		{
			$programName = trim(substr($name, 0, strpos($name, '(')));
			Helpers\Programs::create($programData, $programName, $category->id);
		}
	}
}
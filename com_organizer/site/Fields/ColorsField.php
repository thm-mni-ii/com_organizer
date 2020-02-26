<?php
/**
 * @package     Organizer
 * @extension   com_organizer
 * @author      James Antrim, <james.antrim@nm.thm.de>
 * @copyright   2020 TH Mittelhessen
 * @license     GNU GPL v.3
 * @link        www.thm.de
 */

namespace Organizer\Fields;

use Joomla\CMS\Factory;
use Organizer\Helpers;
use stdClass;

/**
 * Class creates a select box for predefined colors.
 */
class ColorsField extends OptionsField
{
	/**
	 * Type
	 *
	 * @var    String
	 */
	protected $type = 'Colors';

	/**
	 * Returns a select box which contains the colors
	 *
	 * @return string  the HTML for the color select box
	 */
	public function getInput()
	{
		$onChange = empty($this->getAttribute('onchange')) ?
			'' : ' onchange="' . $this->getAttribute('onchange') . '"';
		$html     = '<select name="' . $this->name . '"' . $onChange . '>';
		$options  = $this->getOptions();
		foreach ($options as $option)
		{
			$style    = isset($option->style) ? ' style="' . $option->style . '"' : '';
			$selected = $this->value == $option->value ? ' selected="selected"' : '';
			$html     .= '<option value="' . $option->value . '"' . $selected . $style . '>';
			$html     .= $option->text . '</option>';
		}
		$html .= '</select>';

		return $html;
	}

	/**
	 * Method to get the field options.
	 *
	 * @return  array  The field option objects.
	 */
	protected function getOptions()
	{
		$options = parent::getOptions();

		$tag = Helpers\Languages::getTag();
		$dbo = Factory::getDbo();

		$query = $dbo->getQuery(true);
		$query->select("DISTINCT c.id AS value, c.name_$tag AS text, c.color")
			->from(' #__organizer_colors AS c')
			->order('text');
		$dbo->setQuery($query);

		if (!$colors = Helpers\OrganizerHelper::executeQuery('loadAssocList'))
		{
			return $options;
		}

		foreach ($colors as $color)
		{
			$option        = new stdClass;
			$option->text  = $color['text'];
			$option->value = $color['value'];

			$textColor     = Helpers\Colors::getDynamicTextColor($color['color']);
			$option->style = "background-color:{$color['color']};color:$textColor;";
			$options[]     = $option;
		}

		return $options;
	}
}

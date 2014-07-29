<?php

namespace Wearthe\WeartheBundle\Factory;

class ClothesFactory
{
	public $weatherData;
	public $clothes;

	public function setWeatherData($weatherData)
	{
		$this->weatherData = $weatherData;
	}

	public function getClothes($gender = 'male', $formality = 'informal')
	{
		$weatherConditions = $weatherData['parsed']['conditions'] = array(); // Get this properly

		$highTemp = $weatherData['parsed']['highTemp'] = 25; // Get this properly
		$lowTemp = $weatherData['parsed']['lowTemp'] = 15; // Get this properly

		$temp = 20; // TODO: Fix this

		// Initalise variables
		$tops = array();
		$bottoms[] = array();
		$accessories = array();

		// Define certian conditions
		$sunny = in_array('Sun', $weatherConditions, true);
		$rainny = in_array('Rain', $weatherConditions, true);
		$thundery = in_array('Thunder', $weatherConditions, true);
		$cloudy = in_array('Cloudy', $weatherConditions, true);

		// If it's rainy assume it will be cloudy
		if ($rainny) { $cloudy = true; }

		// If there is thunder assume it will rain
		if ($thundery) { $rainny = true; }

		// Informal Males
		if ($gender == 'male' && $formality == 'informal')
		{
			if ($temp > 20)
			{
				if ($sunny && !$rainny)
				{
					$tops[] = "T-Shirt";
					$bottoms[] = "Shorts";
				}
				elseif ($sunny && $rainny)
				{
					$tops[] = "T-Shirt";
					$tops[] = "Coat";
					$bottoms[] = "Shorts";
				}
			}
			elseif ($temp <= 20 && $temp > 15)
			{
				if ($sunny && $rainny)
				{
					$tops[] = "T-Shirt";
					$tops[] = "Shirt";
					$bottoms[] = "Jeans";
				}
				elseif ($sunny && !$rainny)
				{
					$tops[] = "T-Shirt";
					$bottoms[] = "Jeans";
				}
			}
			elseif ($temp <= 15 && $temp > 6)
			{
				if ($sunny || !$rainny)
				{
					$tops[] = "Shirt";
					$bottoms[] = "Jeans";
				}
			}
			elseif ($temp <= 6)
			{
				if ($rainny || $thundery)
				{
					$tops[] = "Jumper";
					$bottoms[] = "Trousers";
				}
				elseif ($cloudy)
				{
					$tops[] = "Shirt";
					$tops[] = "Jumper";
					$bottoms[] = "Jeans";
				}
			}
		}
		// Formal Males
		elseif ($gender == 'male' && $formality == 'formal')
		{
			if ($temp > 20)
			{
				if ($sunny && !$rainny)
				{
					$tops[] = "Shirt";
					$bottoms[] = "Trousers";
				}
				elseif($sunny && $rainny)
				{
					$tops[] = "Shirt";
					$bottoms[] = "Trousers";
				}
			}
			elseif ($temp <= 20 && $temp > 15)
			{
				if ($sunny && $rainny)
				{
					$tops[] = "Shirt";
					$bottoms[] = "Trousers";
				}
				elseif ($sunny && !$rainny)
				{
					$tops[] = "Shirt";
					$bottoms[] = "Trousers";
				}
			}
			elseif ($temp <= 15 && $temp > 6 && ($sunny || !$rainny))
			{
				if ($sunny || !$rainny)
				{
					$tops[] = "Jacket";
					$tops[] = "Shirt";
					$bottoms[] = "Trousers";
				}
			}
			elseif ($temp <= 6)
			{
				if ($rainny || $thundery)
				{
					$tops[] = "Jacket";
					$tops[] = "Shirt";
					$bottoms[] = "Trousers";
					$accessories[] = "Trilby";
				}
				elseif ($cloudy)
				{
					$tops[] = "Jacket";
					$tops[] = "Shirt";
					$bottoms[] = "Trousers";
				}
			}
		}
		// Informal Females
		elseif ($gender == 'female' && $formality == 'informal')
		{
			if ($temp > 20)
			{
				if ($sunny && !$rainny)
				{
					$tops[] = "Sleeveless Shirt";
					$bottoms[] = "Skirt";
				}
				elseif ($sunny && $rainny)
				{
					$tops[] = "Shirt";
					$tops[] = "Coat";
					$bottoms[] = "Skirt";
				}
			}
			elseif ($temp <= 20 && $temp > 15)
			{
				if ($sunny && $rainny)
				{
					$tops[] = "Shirt";
					$bottoms[] = "Loose Trousers";
				}
				elseif ($sunny && !$rainny)
				{
					$tops[] = "Shirt";
					$bottoms[] = "Skirt";
				}
			}
			elseif ($temp <= 15 && $temp > 6)
			{
				if ($sunny || !$rainny)
				{
					$tops[] = "Shirt";
					$bottoms[] = "Jeans";
				}
				elseif ($rainny || $thundery)
				{
					$tops[] = "Jacket";
					$tops[] = "Shirt";
					$bottoms[] = "Trousers";
				}
			}
			elseif ($temp <= 6)
			{
				if ($cloudy)
				{
					$tops[] = "Jacket";
					$tops[] = "Shirt";
					$bottoms[] = "Trousers";
				}
			}
		}
		// Formal females
		elseif ($gender == 'female' && $formality == 'formal')
		{
			if ($temp > 20)
			{
				if ($sunny && !$rainny)
				{
					$tops[] = "Tank Top / T-Shirt";
					$bottoms[] = "Shorts / Skirt";
				}
				elseif ($sunny && $rainny)
				{
					$tops[] = "Tank Top / T-Shirt";
					$tops[] = "Coat";
					$bottoms[] = "Shorts";
				}
			}
			elseif ($temp <= 20 && $temp > 15)
			{
				if ($sunny && $rainny)
				{
					$tops[] = "T-Shirt";
					$tops[] = "Cardigans";
					$bottoms[] = "Jeans";
				}
				elseif ($sunny && !$rainny)
				{
					$tops[] = "T-Shirt";
					$bottoms[] = "Jeans";
				}
			}
			elseif ($temp <= 15 && $temp > 6)
			{
				if ($sunny || !$rainny)
				{
					$tops[] = "Shirt";
					$bottoms[] = "Jeans";
				}
			}
			elseif ($temp <= 6)
			{
				if ($rainny || $thundery)
				{
					$tops[] = "T-shirt";
					$bottoms[] = "Trousers";
				}
				elseif ($cloudy)
				{
					$tops[] = "Shirt";
					$tops[] = "Jumper";
					$bottoms[] = "Jeans";
				}
			}
		}
		else
		{
			// Gender must be male or female
			// Formality must be formal or informal
			throw new Exception("You must be male or female & you must be formal or informal");
		}

		// Sun or rain accessories
		if ($rainny)
		{
			$accessories[] = "Umbrella";

			if ($formality == 'Formal')
			{
				$tops[] = 'Work Coat';
			}
			else
			{
				$tops[] = 'Coat';
			}
		}
		elseif ($sunny)
		{
			$accessories[] = 'Sun Screen Lotion';

			if ($formality == 'Informal' && $temp >= 20)
			{
				$accessories[] = "Sunglasses";
			}
		}

		// Should suncream be waterproof
		if ($sunny && ($rainny || $thundery))
		{
			$accessories == 'Waterproof Sun Screen Lotion';
		}

		$this->clothes = array($tops, $bottoms, $accessories);
		return $this->clothes;
	}
}

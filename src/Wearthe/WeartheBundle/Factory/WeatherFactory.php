<?php

namespace Wearthe\WeartheBundle\Factory;

class WeatherFactory
{
	public $weatherData;
	public $clothes;

	public function setWeatherData(&$weatherData)
	{
		$this->weatherData = $weatherData;
	}

	public function getClothes($gender = 'male', $formality = 'informal')
	{
		$weatherConditions = $this->weatherData['parsed']['conditions']; // Get this properly

		$highTemp = $this->weatherData['parsed']['highTemp']; // Get this properly
		$lowTemp = $this->weatherData['parsed']['lowTemp']; // Get this properly

		$temp = ($highTemp + $lowTemp) / 2;

		// Initalise variables
		$tops = array();
		$bottoms = '';
		$accessories = array();

		// Define certian conditions
		$clear = in_array('clear', $weatherConditions, true);
		$rain = in_array('rain', $weatherConditions, true);
		$storm = in_array('storm', $weatherConditions, true);
		$cloudy = in_array('cloudy', $weatherConditions, true);
		$partlyCloudy = in_array('cloudy', $weatherConditions, true);
		$tornado = in_array('tornado', $weatherConditions, true);
		$wind = in_array('wind', $weatherConditions, true);
		$snow = in_array('snow', $weatherConditions, true);
		$fog = in_array('fog', $weatherConditions, true);

		$hot = $warm = $cool = $cold = false;

		if ($temp > 20)
		{
			$hot = true;
		}
		elseif ($temp <= 20 && $temp > 15)
		{
			$warm = true;
		}
		elseif ($temp <= 15 && $temp > 6)
		{
			$cool = true;
		}
		elseif ($temp <= 6)
		{
			$cold = true;
		}

		// Informal Males
		if ($gender == 'male' && $formality == 'informal')
		{
			if ($hot)
			{
				$tops[] = "t-shirt";

				if (
					($clear || $partlyCloudy || $cloudy) &&
					!($rain || $storm || $tornado || $wind || $snow))
				{
					$bottoms = "shorts";
				}
				else
				{
					$bottoms = "trousers";
				}
			}
			elseif ($warm || $cool)
			{
				if (
					($clear || $partlyCloudy || $cloudy) &&
					!($rain || $storm || $tornado || $wind || $snow))
				{
					$bottoms = "jeans";
				}
				else
				{
					$bottoms = "trousers";
				}

				if ($cool)
				{
					$tops[] = 'jumper';
				}

				$tops[] = "t-shirt";
			}
			elseif ($cold)
			{
				if ($storm || $rain || $snow)
				{
					$bottoms = "trousers";
				}
				else
				{
					$bottoms = "jeans";
				}

				$tops[] = "t-shirt";
				$tops[] = 'jumper';
			}
		}
		// Formal Males
		elseif ($gender == 'male' && $formality == 'formal')
		{
			$tops[] = "shirt";
			$bottoms = "trousers";

			if ($warm || $cool || $cold)
			{
				$tops[] = "jacket";
			}
		}
		// Informal Females
		elseif ($gender == 'female' && $formality == 'informal')
		{
			if ($hot)
			{
				if ($sunny && !$rainny)
				{
					$tops[] = "Sleeveless Shirt";
					$bottoms = "Skirt";
				}
				elseif ($sunny && $rainny)
				{
					$tops[] = "Shirt";
					$bottoms = "Skirt";
				}
			}
			elseif ($warm)
			{
				if ($sunny && $rainny)
				{
					$tops[] = "Shirt";
					$bottoms = "Loose Trousers";
				}
				elseif ($sunny && !$rainny)
				{
					$tops[] = "Shirt";
					$bottoms = "Skirt";
				}
			}
			elseif ($cool)
			{
				$tops[] = "Shirt";

				if ($sunny || !$rainny)
				{
					$bottoms = "Jeans";
				}
				elseif ($rainny || $thundery)
				{
					$tops[] = "Jacket";
					$bottoms = "Trousers";
				}
			}
			elseif ($cold)
			{
				if ($cloudy)
				{
					$tops[] = "Jacket";
					$tops[] = "Shirt";
					$bottoms = "Trousers";
				}
			}
		}
		// Formal females
		elseif ($gender == 'female' && $formality == 'formal')
		{
			if ($hot)
			{
				if ($sunny && !$rainny)
				{
					$tops[] = "Tank Top / T-Shirt";
					$bottoms = "Shorts / Skirt";
				}
				elseif ($sunny && $rainny)
				{
					$tops[] = "Tank Top / T-Shirt";
					$bottoms = "Shorts";
				}
			}
			elseif ($warm)
			{
				if ($sunny && $rainny)
				{
					$tops[] = "T-Shirt";
					$tops[] = "Cardigans";
					$bottoms = "Jeans";
				}
				elseif ($sunny && !$rainny)
				{
					$tops[] = "T-Shirt";
					$bottoms = "Jeans";
				}
			}
			elseif ($cool)
			{
				if ($sunny || !$rainny)
				{
					$tops[] = "Shirt";
					$bottoms = "Jeans";
				}
			}
			elseif ($cold)
			{
				if ($rainny || $thundery)
				{
					$tops[] = "T-shirt";
					$bottoms = "Trousers";
				}
				elseif ($cloudy)
				{
					$tops[] = "Shirt";
					$tops[] = "Jumper";
					$bottoms = "Jeans";
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
		if ($rain || $storm || $snow || $tornado)
		{
			if (!$tornado)
			{
				$accessories[] = "umbrella";
			}

			if ($formality == 'Formal')
			{
				$tops[] = 'workcoat';
			}
			else
			{
				$tops[] = 'coat';
			}
		}
		elseif ($clear && ($warm || $hot || $cool))
		{
			$accessories[] = 'suncream';

			if ($formality == 'Informal' && $temp >= 20)
			{
				$accessories[] = "sunglasses";
			}
		}

		// Should suncream be waterproof
		if (($rain || $storm || $snow) && ($clear && ($warm || $hot || $cool)))
		{
			$accessories == 'waterproof-suncream';
		}

		$this->clothes = array(
			'tops' => $tops,
			'bottoms' => $bottoms,
			'accessories' => $accessories
		);

		return $this->clothes;
	}
}

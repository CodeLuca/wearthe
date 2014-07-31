<?php

namespace Wearthe\WeartheBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Wearthe\WeartheBundle\Factory\ApiFactory;
use Wearthe\WeartheBundle\Factory\WeatherFactory;

class ApiController extends Controller
{
	public function mainAction($formality, $gender, $location, $locationType)
	{
		$apiFactory = new ApiFactory($this->container->getParameter('api_key'));
		$weatherFactory = new WeatherFactory();

		switch ($locationType)
		{
			case 1:
			default:
				$apiFactory->setSpecificLocation($location);
				break;

			case 2:
				$apiFactory->setGeneralisedLocation($location);
				break;
		}

		$apiFactory->getData();
		$apiFactory->parseData();
		$weatherData = $apiFactory->getWeatherData();
		$weatherFactory->setWeatherData($weatherData);
		$clothes = $weatherFactory->getClothes($gender, $formality);
		$final = $clothes;

		$final['weather'] = array(
			'High' => $weatherData['parsed']['highTemp'],
			'Low' => $weatherData['parsed']['lowTemp'],
		);

		$final['times-temp'] = array();
		$final['times-overall'] = array();
		$final['times-summary'] = array();

		for ($i=6; $i <= 22 ; $i++)
		{
			$final['times-temp'][$i] = $weatherData['parsed']['time'][$i]['temp'];
			$final['times-overall'][$i] = $weatherData['parsed']['time'][$i]['icon'];
			$final['times-summary'][$i] = $weatherData['parsed']['time'][$i]['summary'];
		}

		// $dump = json_encode($weatherData['parsed']);
		// $dump = json_encode($clothes);

		return $this->render('WeartheWeartheBundle:Api:index.json.twig', array('data' => json_encode($final));
	}
}

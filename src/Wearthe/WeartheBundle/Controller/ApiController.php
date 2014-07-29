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

		return $this->render('WeartheWeartheBundle:Api:index.json.twig');
	}
}

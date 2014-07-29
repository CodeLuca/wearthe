<?php

namespace Wearthe\WeartheBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Wearthe\WeartheBundle\Factory\ApiFactory;

class DefaultController extends Controller
{
	public function indexAction($formality, $gender, $location, $locationType)
	{
		$apiFactory = new ApiFactory($this->container->getParameter('api_key'));
		$location = '37.8267,-122.423';

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

		$dump = $apiFactory->getData();

		return $this->render('WeartheWeartheBundle:Default:index.html.twig');
	}
}

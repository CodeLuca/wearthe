<?php

namespace Wearthe\WeartheBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Wearthe\WeartheBundle\Factory\ApiFactory;
use Wearthe\WeartheBundle\Factory\WeatherFactory;

class DefaultController extends Controller
{
	public function indexAction()
	{
		return $this->render('WeartheWeartheBundle:Default:index.html.twig');
	}
}

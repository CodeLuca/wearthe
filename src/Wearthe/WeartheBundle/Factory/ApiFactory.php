<?php

namespace Wearthe\WeartheBundle\Factory;

class ApiFactory
{
	protected $apiKey;
	protected $location;
	protected $longitude;
	protected $latitude;
	protected $hours;

	/**
	 * Class Constructor
	 *
	 * @param string $apiKey The API Key for forecast.io
	 * @return /Wearthe/WeartheBundle/Factory/ApiFactory
	 */
	public function __construct($apiKey)
	{
		$this->apiKey = $apiKey;
	}

	/**
	 * Set a location with co-ordinates
	 *
	 * @param string $location Location in co-ordinated formed of LONGITUDE,LATITUDE
	 * @return array $locationArray Array of longitude, latitude
	 * @access public
	 */
	public function setSpecificLocation($location)
	{
		$locationArray = explode(',', $location);

		$this->longitude = $locationArray[0];
		$this->latitude = $locationArray[1];

		return $locationArray;
	}

	/**
	 * Set a location without co-ordinated
	 *
	 * We use google maps API to turn an address into co-ordinates
	 *
	 * @param string $location The location in the form of address
	 * @return array The longitude & latitude
	 * @static
	 * @access public
	*/
	public static function setGeneralisedLocation($location)
	{
		$address = $location;
		$prepAddr = str_replace(' ','+',$address);
		$geocode = @file_get_contents('http://maps.google.com/maps/api/geocode/json?address='.$prepAddr.'&sensor=false');
		$output = @json_decode($geocode);
		$this->latitude = $output->results[0]->geometry->location->lat;
		$this->longitude = $output->results[0]->geometry->location->lng;

		return array($longitude, $latitude);
	}

	/**
	 * Get the weather data from forecast.io
	 * @return array The overall weather data
	 */
	public function getData()
	{
		$apiSite = 'https://api.forecast.io/forecast/';

		// Get announcements file
		$weatherFile = @file_get_contents($apiSite . $this->apiKey . '/' . $this->latitude . ',' . $this->longitude);
		$this->weatherData['day'] = @json_decode($weatherFile, true);

		$this->getHours();

		foreach ($this->hours as $normal => $unixTimestamp)
		{
			$weatherFile = @file_get_contents($apiSite . $this->apiKey . '/' . $this->latitude . ',' . $this->longitude . ',' . $unixTimestamp);
			$this->weatherData[$normal] = @json_decode($weatherFile, true);
		}

		//TODO: Set up call for each hour we want to know
		return $this->weatherData;
	}

	/**
	 * Get the unix timestamps of the different hours of the day
	 * @return array The hours
	 */
	protected function getHours()
	{
		$this->hours = array();

		for ($i=6; $i<=21; $i++)
		{
			$this->hours[$i] = strtotime($i . ':00');
		}

		return $this->hours;
	}

	public function parseData()
	{
		$this->weatherData['parsed']['highTemp'] = $this->weatherData['day']['daily']['data']['apparentTemperatureMax'] ?: $this->weatherData['day']['daily']['data']['temperatureMax'];
		$this->weatherData['parsed']['lowTemp'] = $this->weatherData['day']['daily']['data']['apparentTemperatureMin'] ?: $this->weatherData['day']['daily']['data']['temperatureMin'];

		// Convert F to C
		$this->weatherData['parsed']['highTemp'] = $this->weatherData['parsed']['highTemp'] * (9/5) + 32;
		$this->weatherData['parsed']['lowTemp'] = $this->weatherData['parsed']['lowTemp'] * (9/5) + 32;

		foreach ($this->hours as $normal => $unixTimestamp)
		{
			$this->weatherData['parsed']['time'][$normal] = $this->weatherData[$normal]['currently']['apparentTemperature'] ?: $this->weatherData[$normal]['currently']['temperature'];

			$this->weatherData['parsed']['time'][$normal] = $this->weatherData['parsed']['time'][$normal] * (9/5) + 32;

			// Add weather conditions to conditions array
		}


	}
}

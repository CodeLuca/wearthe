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
	 * @param string $location Location in co-ordinated formed of LATITUDE,LONGITUDE
	 * @return array $locationArray Array of longitude, latitude
	 * @access public
	 */
	public function setSpecificLocation($location)
	{
		$locationArray = explode(',', $location);

		$this->latitude = $locationArray[0];
		$this->longitude = $locationArray[1];

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
		$url = $apiSite . $this->apiKey . '/' . $this->latitude . ',' . $this->longitude;
		$weatherFile = @file_get_contents($url);
		$this->weatherData['day'] = @json_decode($weatherFile, true);

		$this->getHours();

		foreach ($this->hours as $normal => $unixTimestamp)
		{
			$url = $apiSite . $this->apiKey . '/' . $this->latitude . ',' . $this->longitude . ',' . $unixTimestamp;
			$weatherFile = @file_get_contents($url);
			$this->weatherData['time'][$normal] = @json_decode($weatherFile, true);
		}

		return $this->weatherData;
	}

	/**
	 * Get the unix timestamps of the different hours of the day
	 * @return array The hours
	 */
	protected function getHours()
	{
		$this->hours = array();

		for ($i = 6; $i <= 22; $i++)
		{
			$this->hours[$i] = strtotime($i . ':00');
		}

		return $this->hours;
	}

	public function parseData()
	{
		// Initalise variables
		$this->weatherData['parsed'] = array();

		// Get high and low for the day
		$this->weatherData['parsed']['highTemp'] = $this->weatherData['day']['daily']['data'][1]['apparentTemperatureMax'] ?: $this->weatherData['day']['daily']['data']['temperatureMax'];
		$this->weatherData['parsed']['lowTemp'] = $this->weatherData['day']['daily']['data'][1]['apparentTemperatureMin'] ?: $this->weatherData['day']['daily']['data']['temperatureMin'];

		// Convert F to C
		$this->weatherData['parsed']['highTemp'] = $this->fToC($this->weatherData['parsed']['highTemp']);
		$this->weatherData['parsed']['lowTemp'] = $this->fToC($this->weatherData['parsed']['lowTemp']);

		$this->weatherData['parsed']['conditions'] = array();
		$this->weatherData['parsed']['time'] = array();

		foreach ($this->hours as $normal => $unixTimestamp)
		{
			$this->weatherData['parsed']['time'][$normal] = array();

			// Get temperature for hour - Use apparentTemp if available.
			$this->weatherData['parsed']['time'][$normal]['temp'] = $this->weatherData['time'][$normal]['currently']['apparentTemperature'] ?: $this->weatherData['time'][$normal]['currently']['temperature'];

			// Degrees F to C
			$this->weatherData['parsed']['time'][$normal]['temp'] = $this->fToC($this->weatherData['parsed']['time'][$normal]['temp']);

			// Icon (AKA Overall weather condition)
			$this->weatherData['parsed']['time'][$normal]['icon'] = $this->weatherData['time'][$normal]['currently']['icon'];

			// For alt text, the summary
			$this->weatherData['parsed']['time'][$normal]['summary'] = $this->weatherData['time'][$normal]['currently']['summary'];

			// Create an array of conditions during the day
			$condition = $this->calculateCondition($this->weatherData['time'][$normal]['currently']['icon']);

			if (!in_array($condition, $this->weatherData['parsed']['conditions'], true))
			{
				$this->weatherData['parsed']['conditions'][] = $condition;
			}

			unset($condition);
		}

		// Add daily icon from day
		if (!in_array($this->calculateCondition($this->weatherData['day']['daily']['data'][1]['icon']), $this->weatherData['parsed']['conditions'], true))
		{
			$this->weatherData['parsed']['conditions'][] = $this->calculateCondition($this->weatherData['day']['daily']['data'][1]['icon']);
		}

		// Add currently icon from day
		if (!in_array($this->calculateCondition($this->weatherData['day']['currently']['icon']), $this->weatherData['parsed']['conditions'], true))
		{
			$this->weatherData['parsed']['conditions'][] = $this->calculateCondition($this->weatherData['day']['currently']['icon']);
		}
	}

	public function getWeatherData()
	{
		return $this->weatherData;
	}

	private function fToC($f)
	{
		return round((5/9) * ($f - 32));
	}

	private function calculateCondition($icon)
	{
		switch ($icon)
		{
			case 'fog':
				$condition = 'fog';
				break;

			case 'rain':
				$condition = 'rain';
				break;

			case 'snow':
			case 'sleet':
			case 'hail':
				$condition = 'snow';
				break;

			case 'wind':
				$condition = 'wind';
				break;

			case 'thunderstorm':
				$condition = 'storm';
				break;

			case 'tornado':
				$condition = 'tornado';
				break;

			case 'cloudy':
				$condition = 'cloudy';
				break;

			case 'partly-cloudy-day':
			case 'partly-cloudy-night':
				$condition = 'partly-cloudy';
				break;

			case 'clear-day':
			case 'clear-night':
			default:
				$condition = 'clear';
				break;
		}

		return $condition;
	}
}

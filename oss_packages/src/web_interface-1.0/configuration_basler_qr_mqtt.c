#include "defines.h"
#include "settings.h"
#include "settings_defines.h"

void *web_s_configuration(void) {

  char* val = NULL;

  struct setting settings[SETTINGS_COUNT] = {
	  {	"POLLING_TIME", 		"polling_Interval", 	""	},
	  {	"IP_ADDRESS",			"basler_address", 		""	},
	  {	"IP_ADDRESS",			"mosquitto_address",		""	},
	  {	"TCP_PORT",				"mosquitto_port",		""	},
	  {	"TOPIC",			"mosquitto_topic",		""	},
  };

  /* Initialize settings from settings.h */
  init_settings(settings, SETTINGS_COUNT);

  /* Start printing page */
  fprintf(output, "<form action=\"web_c_configuration.cgi\" method=post>\n");

  start_box();
  fprintf(output, "<h1>%s</h1>\n", get_text("CONFIGURATION"));
  end_box();

  /* Modbus */
  start_box();
  fprintf(output, "<h3>%s</h3>\n", get_text("MODBUS_DEVICE"));

  fprintf(output, "%s", settings[SETTING_POLLING_TIME].name);
  print_input("text", settings[SETTING_POLLING_TIME].input_name, settings[SETTING_POLLING_TIME].value, "float: right; margin-right: 500px;", "");
  fprintf(output, "<br><br>");

  fprintf(output, "%s", settings[SETTING_BASLER_ADDRESS].name);
  print_input("text", settings[SETTING_BASLER_ADDRESS].input_name, settings[SETTING_BASLER_ADDRESS].value, "float: right; margin-right: 500px;", "");
  fprintf(output, "<br><br>");

  end_box(); /* box */

  /* MQTT */
  start_box();
  fprintf(output, "<h3>MQTT</h3>\n");

  fprintf(output, "%s", settings[SETTING_MOSQUITTO_ADDRESS].name);
  print_input("text", settings[SETTING_MOSQUITTO_ADDRESS].input_name, settings[SETTING_MOSQUITTO_ADDRESS].value, "float: right; margin-right: 500px;", "");
  fprintf(output, "<br><br>");

  fprintf(output, "%s", settings[SETTING_MOSQUITTO_PORT].name);
  print_input("text", settings[SETTING_MOSQUITTO_PORT].input_name, settings[SETTING_MOSQUITTO_PORT].value, "float: right; margin-right: 500px;", "");
  fprintf(output, "<br><br>");

  fprintf(output, "%s", settings[SETTING_MOSQUITTO_TOPIC].name);
  print_input("text", settings[SETTING_MOSQUITTO_TOPIC].input_name, settings[SETTING_MOSQUITTO_TOPIC].value, "float: right; margin-right: 500px;", "");
  fprintf(output, "<br><br>");

  end_box(); /* box */

  /* Button */
  start_box();
  print_input("submit", "btnSubConfiguration", "OK", "margin-right:10px;", get_text("SAVE_TEXT"));
  end_box();

  fprintf(output, "</form>\n");

  return NULL;
}

void *web_c_configuration(void) {
  FILE *config;

  char line[200];

  /* Open config file for rewrite */
  config = fopen("/tmp/new_config", "w+");
  fputs("##### Container Configuration #####\n", config);

  /* Timing */
  fputs("##### Timing #####\n", config);	get_line(line, "polling_Interval");
  fputs(line, config);

  /* Modbus */
  fputs("\n##### Basler #####\n", config);
  get_line(line, "basler_address");
  fputs(line, config);


  /* MQTT */
  fputs("\n##### MQTT #####\n", config);
  get_line(line, "mosquitto_address");
  fputs(line, config);
  get_line(line, "mosquitto_port");
  fputs(line, config);
  get_line(line, "mosquitto_topic");
  fputs(line, config);

  /* Close data */
  fclose(config);

  sleep(1);

  web_s_configuration();

  return NULL;
}

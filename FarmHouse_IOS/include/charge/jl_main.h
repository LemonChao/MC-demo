/***************************************************************************
 *
 * Copyright (c) 2012-2015 JingLian Inc.  All Rights Reserved
 *
 * THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF JingLian Inc.
 * The copyright notice above does not evidence any actual or intended
 * publication of such source code.
 *  created by ShiShan Li 2012-05-28
 ****************************************************************************/
#ifndef	__JL_MAIN_H__
#define	__JL_MAIN_H__

#define		IPV4_ADDR_LEN				16

typedef	enum net_type_e
{
	E_NET_TYPE_LAN,
	E_NET_TYPE_WIFI,
	E_NET_TYPE_3G
}net_type_e;

typedef	struct
{
	unsigned int	sendfile_speed;
	unsigned int	syslog_level;
	unsigned int	watchdog;
	unsigned int	deviceId;
	unsigned int	signal_port;
	unsigned int	send_video_pack_len;
	unsigned int	video_decrease_time;
	unsigned int	video_increase_time;
	unsigned int	video_max_bitrate;
	unsigned int	video_min_bitrate;
	unsigned int	video_max_framerate;
	unsigned int	video_min_framerate;
	unsigned int	video_width;
    unsigned int	video_heigth;
    unsigned int    debug; //indicate debug or release
    net_type_e		net_type;
    unsigned int    picture_quality;
    unsigned int halt_wait_time;
	char	server_ip[IPV4_ADDR_LEN];	
}system_config_t;

typedef	enum stream_state_e
{
	E_STREAM_OFF,
	E_STREAM_ON,
    E_STREAM_CAP
}stream_state_e;

typedef	enum lcd_state_e
{
	E_LCD_STATE_ON,
	E_LCD_STATE_OFF
}lcd_state_e;

typedef	enum flash_led_e
{
	E_FLASH_LED_OFF,
	E_FLASH_LED_ON
}flash_led_e;

typedef	enum key_mode_e
{
	E_KEY_MODE_ABC,
	E_KEY_MODE_abc,
	E_KEY_MODE_123
}key_mode_e;


typedef	struct
{
	unsigned int	video_lost_times;
	unsigned int	video_nonlost_times;
	unsigned int	video_width;
	unsigned int 	video_height;
	unsigned int	video_cur_bitrate;
	unsigned int	video_cur_framerate;
    unsigned int	video_ts;
    unsigned int	audio_ts;
	unsigned short	video_seqno;
	unsigned short	audio_seqno;	
	unsigned int	focus_num;
	stream_state_e	stream_state;
	lcd_state_e		lcd_state;
	flash_led_e		flash_led_state;
	key_mode_e		key_mode;
	net_type_e		net_type;
	unsigned int	net_signal;
	unsigned int	battery;
	unsigned int	c2j_msgq_id;
	unsigned int	j2c_msgq_id;
    unsigned int    have_net_signal;

    unsigned int    picture_quality;
    unsigned int halt_wait_time;
}system_param_t;

typedef	struct
{
	unsigned int	deviceId;
	unsigned int	audio_listen_port;
	unsigned int	video_listen_port;
	unsigned int	syslog_level;
	char	server_ip[20];
}devavtp_config_t;

extern system_config_t		g_system_config;

extern system_param_t		g_system_param;

int	init_system_config();
//int video_audio_init();

#endif	//__JL_MAIN_H__


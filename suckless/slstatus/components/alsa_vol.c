#include <alsa/asoundlib.h>
#include <alsa/mixer.h>

#include "../util.h"

const char *
alsa_vol(const char * card)
{
    long vol;
    long min, max;
    snd_mixer_t *handle;
    snd_mixer_selem_id_t *sid;
    
    char temp[20];

    strcpy(temp, card);

    const char * card_name = strtok(temp, ":");
    const char * selem_name = strtok(NULL, "");

    snd_mixer_open(&handle, 0);
    snd_mixer_attach(handle, card_name);
    snd_mixer_selem_register(handle, NULL, NULL);
    snd_mixer_load(handle);

    snd_mixer_selem_id_alloca(&sid);
    snd_mixer_selem_id_set_index(sid, 0);
    snd_mixer_selem_id_set_name(sid, selem_name);
    
    snd_mixer_elem_t* elem = snd_mixer_find_selem(handle, sid);

    snd_mixer_selem_get_playback_volume_range(elem, &min, &max);    

    snd_mixer_selem_get_playback_volume(elem, 0, &vol);
    
    vol -= min;
    max -= min;
    vol = 100 * vol / max;

    return (char *)bprintf("%ld", vol);
}
# LosOce_Cron
Los Oceanic - Cron Jobs: Slightly modified version of ESX-Org/cron to use 12 hour time. H: [01-12] M: [00-59]

### Hypothosis

The ability to schedule tasks/functions or routines within server/local time.

## Prerequisites

* nill

Just add it to your server.cfg

```
start LosOce_Cron
```

## The Cron

```
---------------------------------------------
--  Execute task 05:10 & 17:10, every day  --

--  function CronTask(day, hour, minute)
--  if day ~= nil then
--  	print('Task done')
--  end

--  TriggerEvent('LosOce_Cron:Schedule', 05, 10, CronTask)
```

## License

This project is licensed under the GNU v3.0 License - see the [LICENSE.md](LICENSE) file for details

## Acknowledgments

* [ESX-Org/cron](https://github.com/ESX-Org/cron) - All Contributers

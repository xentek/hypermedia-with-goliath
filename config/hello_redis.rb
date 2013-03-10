config['redis'] = Redis.new(host: '0.0.0.0',
                            port: 6379,
                            db: 15,
                            thread_safe: true,
                            driver: :synchrony)

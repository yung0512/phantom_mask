WEEK_DAYS_MAP = {
  'Mon' => 1,
  'Tue' => 2,
  'Wed' => 3,
  'Thur' => 4,
  'Fri' => 5,
  'Sat' => 6,
  'Sun' => 7
}

def parse_open_hours(open_hours_string)
  result = {
    week_days: {},
  }
  # ex: "Mon-Fri 9:00-18:00" or "Mon - Fri 08:00 - 17:00 / Sat, Sun 08:00 - 12:00"
  # first split by '/' to get each different open hours
  open_hours_string.split(' / ').map do |open_hours|
    #then split by '-' to get open hours for each day

    # ex: "Mon-Fri 9:00-18:00"
    # use regular expression to check there is two '-' in the string
    if open_hours.scan(/-/).size == 2
      #Fri - Sun 20:00 - 02:00
      #split by space to get week days and open interval and filter out '-'
      start_day, end_day, start_time, end_time = open_hours.split(' ').filter { |str| str != '-' }
      # get week day number from WEEK_DAYS_MAP
      
      # return array of week days and open interval
      # ex: {
      #   week_days: [{
      #     1 => {
      #       start_time: "9:00",
      #       end_time: "18:00"
      #     }]
      # }
      (WEEK_DAYS_MAP[start_day]..WEEK_DAYS_MAP[end_day]).map do |week_day| 
        result[:week_days][week_day.to_s] = {
          start_at: {
            hour: Time.parse(start_time).hour,
            min: Time.parse(start_time).min
          },
          close_at: { 
            hour: Time.parse(end_time).hour,
            min: Time.parse(end_time).min
          }
        }
      end
    else
      #there is only one '-', it means the open week day is not consective
      # ex: "Mon, Wed, Fri 9:00-18:00"
      # so we need to split by ',' instead of '-'
      # Mon, Wed, Fri 9:00 - 18:00 or Sun 08:00 - 12:00
      # to check if there is any ',' in the string
      if open_hours.scan(/,/).size > 0
        # split by ',' to get each week day
        # ex: ["Mon", "Wed", "Fri 9:00 - 18:00"]
        week_days = open_hours.split(',')
        
        # get open interval and last week day
        # ex: "9:00-18:00"
        last_week_day, start_time, end_time = week_days.pop.split(' ').filter { |str| str != '-' } # it should return only three elements
        week_days.push(last_week_day)

        week_days.map do |week_day|
          result[:week_days][WEEK_DAYS_MAP[week_day.strip]] =
            {
              start_at: {
                hour: Time.parse(start_time).hour,
                min: Time.parse(start_time).min
              },
              close_at: {
                hour: Time.parse(end_time).hour,
                min: Time.parse(end_time).min
              }
            }
        end
      else
        # there is no ',' in the string, it means there is only one week day
        # ex: "Sun 08:00 - 12:00"
        # split by space to get week day and open interval
        # ex: ["Sun", "08:00", "12:00"]
        week_day, start_time, end_time = open_hours.split(' ').filter { |str| str != '-' }
        result[:week_days][WEEK_DAYS_MAP[week_day]] = 
          {
            start_at: {
              hour: Time.parse(start_time).hour,
              min: Time.parse(start_time).min
            },
            close_at: {
              hour: Time.parse(end_time).hour,
              min: Time.parse(end_time).min
            }
          }
      end
    end
  end

  result.to_json
end

namespace :db do
  desc 'Load data from json file'
  task :load_pharmacy => :environment do
    # Load data from json file 
    data_path = Rails.root.join('db', 'data', 'pharmacies.json')

    # Parse json file
    File.open(data_path) do |file|
      pharmacies = JSON.parse(file.read)

      # Create pharmacies
      pharmacies.each do |pharmacy|
        print pharmacy
        p = Pharmacy.create(
          name: pharmacy["name"],
          cash_balance: pharmacy["cashBalance"],
          open_hours: parse_open_hours(pharmacy["openingHours"])
        )
        
        # Create masks
        pharmacy["masks"].each do |mask|
          #if there is no mask with the same name, create a new mask
          if Mask.where(name: mask["name"]).size == 0
            m = Mask.create(
              name: mask["name"],
            )

            # Create pharmacy mask
            PharmacyMask.create(
              pharmacy_id: p.id,
              mask_id: m.id,
              price: mask["price"],
            )
          else
            #if there is a mask with the same name, get the mask
            m = Mask.find_by(name: mask["name"])

            # Create pharmacy mask
            PharmacyMask.create(
              pharmacy_id: p.id,
              mask_id: m.id,
              price: mask["price"],
            )
          end

        end
      end
    end
  end

  desc 'Load data from json file'
  task :load_user => :environment do
    data_path = Rails.root.join('db', 'data', 'users.json')

    # Parse json file
    File.open(data_path) do |file|
      users = JSON.parse(file.read)

      # Create users
      users.each do |user|
        u = User.create(
          name: user["name"],
          cash_balance: user["cashBalance"],
        )

        # Create user transactions
        user["purchaseHistories"].each do |transaction|
          mask = Mask.find_by(name: transaction["maskName"])
          puts mask.name
          pharmacy = Pharmacy.find_by(name: transaction["pharmacyName"])
          puts pharmacy.name
          pharmacy_mask = PharmacyMask.find_by(pharmacy_id: pharmacy.id, mask_id: mask.id)
          puts pharmacy_mask.id
          pharamcy_id = pharmacy_mask.pharmacy_id
          MaskTransaction.create(
            user_id: u.id,
            pharmacy_id: pharamcy_id,
            pharmacy_mask_id: pharmacy_mask.id,
            amount: transaction["transactionAmount"],
            purchase_at: Time.parse(transaction["transactionDate"]).to_datetime,
          )
        end
      end
    end

  end
end
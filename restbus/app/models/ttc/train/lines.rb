module Ttc
  module Train
    LINES = {
      :"Bloor-Danforth" => {
        :id => 2,
        :name => "Bloor-Danforth",
        :stations => {
          :Bathurst => {
            :google_maps_name => "Bathurst",
            :id => 46,
            :latitude => 43.6660011,
            :longitude => -79.4112152,
            :name => "Bathurst"
          },
          :Bay => {
            :google_maps_name => "Bay Station",
            :id => 49,
            :latitude => 43.6701472,
            :longitude => -79.3906947,
            :name => "Bay"
          },
          :"Bloor-Yonge" => {
            :google_maps_name => "Bloor-Yonge Station",
            :id => 50,
            :latitude => 43.6709058,
            :longitude => -79.38563719999999,
            :name => "Bloor-Yonge"
          },
          :Broadview => {
            :id => 53,
            :latitude => 123,
            :longitude => 456,
            :name => "Broadview"
          },
          :"Castle Frank" => {
            :id => 52,
            :latitude => 123,
            :longitude => 456,
            :name => "Castle Frank"
          },
          :Chester => {
            :google_maps_name => "Chester",
            :id => 54,
            :latitude => 43.6782356,
            :longitude => -79.3524545,
            :name => "Chester"
          },
          :Christie => {
            :google_maps_name => "Christie",
            :id => 45,
            :latitude => 43.6641094,
            :longitude => -79.4183587,
            :name => "Christie"
          },
          :Coxwell => {
            :id => 58,
            :latitude => 123,
            :longitude => 456,
            :name => "Coxwell",
            google_maps_name: 'Coxwell'
          },
          :Donlands => {
            :id => 56,
            :latitude => 123,
            :longitude => 456,
            :name => 'Donlands',
            google_maps_name: 'Donlands'
          },
          :Dufferin => {
            :google_maps_name => "Dufferin",
            :id => 43,
            :latitude => 43.6600496,
            :longitude => -79.4354025,
            :name => "Dufferin"
          },
          :"Dundas West" => {
            :id => 41,
            :latitude => 123,
            :longitude => 456,
            :name => "Dundas West"
          },
          :Greenwood => {
            :id => 57,
            :latitude => 123,
            :longitude => 456,
            :name => "Greenwood",
            google_maps_name: 'Greenwood'
          },
          :"High Park" => {
            :id => 39,
            :latitude => 123,
            :longitude => 456,
            :name => "High Park"
          },
          :Islington => {
            :id => 34,
            :latitude => 123,
            :longitude => 456,
            :name => 'Islington',
            google_maps_name: 'Islington Station'
          },
          :Jane => {
            :id => 37,
            :latitude => 123,
            :longitude => 456,
            :name => "Jane"
          },
          :Keele => {
            :id => 40,
            :latitude => 123,
            :longitude => 456,
            :name => "Keele"
          },
          :Kennedy => {
            :google_maps_name => "Kennedy",
            :id => 63,
            :latitude => 43.7321497,
            :longitude => -79.2641089,
            :name => "Kennedy"
          },
          :Kipling => {
            :id => 33,
            :latitude => 123,
            :longitude => 456,
            :name => "Kipling"
          },
          :Lansdowne => {
            :google_maps_name => "Lansdowne",
            :id => 42,
            :latitude => 43.6590797,
            :longitude => -79.442801,
            :name => "Lansdowne"
          },
          :"Main Street" => {
            :google_maps_name => "Main Street",
            :id => 60,
            :latitude => 43.6890219,
            :longitude => -79.3016857,
            :name => "Main Street"
          },
          :"Old Mill" => {
            :id => 36,
            :latitude => 123,
            :longitude => 456,
            :name => "Old Mill"
          },
          :Ossington => {
            :google_maps_name => "Ossington",
            :id => 44,
            :latitude => 43.662371,
            :longitude => -79.4263058,
            :name => "Ossington"
          },
          :Pape => {
            :id => 55,
            :latitude => 123,
            :longitude => 456,
            :name => "Pape",
            google_maps_name: 'Pape Station'
          },
          :"Royal York" => {
            :google_maps_name => "Royal York Station",
            :id => 35,
            :latitude => 43.6484349,
            :longitude => -79.5097437,
            :name => "Royal York"
          },
          :Runnymede => {
            :id => 38,
            :latitude => 123,
            :longitude => 456,
            :name => 'Runnymede',
            google_maps_name: 'Runnymede Station'
          },
          :Sherbourne => {
            :google_maps_name => "Sherbourne",
            :id => 51,
            :latitude => 43.6721674,
            :longitude => -79.376432,
            :name => "Sherbourne"
          },
          :Spadina => {
            :google_maps_name => "Spadina Station",
            :id => 47,
            :latitude => 43.6673525,
            :longitude => -79.40383469999999,
            :name => "Spadina"
          },
          :"St. George" => {
            :id => 48,
            :latitude => 123,
            :longitude => 456,
            :name => "St. George"
          },
          :"Victoria Park" => {
            :id => 61,
            :latitude => 123,
            :longitude => 456,
            :name => "Victoria Park"
          },
          :Warden => {
            :id => 62,
            :latitude => 123,
            :longitude => 456,
            :name => "Warden"
          },
          :Woodbine => {
            :id => 59,
            :latitude => 123,
            :longitude => 456,
            :name => "Woodbine"
          }
        }
      },
      :"Scarborough-RT" => {
        :id => 3,
        :name => "Scarborough RT",
        :stations => {}
      },
      :Sheppard => {
        :id => 4,
        :name => "Sheppard",
        :stations => {
          :Bayview => {
            :google_maps_name => "Bayview",
            :id => 65,
            :latitude => 43.766874,
            :longitude => -79.3863038,
            :name => "Bayview"
          },
          :Bessarion => {
            :google_maps_name => "Bessarion Station - Eastbound Platform",
            :id => 66,
            :latitude => 43.76906719999999,
            :longitude => -79.37589779999999,
            :name => "Bessarion"
          },
          :"Don Mills" => {
            :google_maps_name => "Don Mills",
            :id => 68,
            :latitude => 43.7757094,
            :longitude => -79.34532209999999,
            :name => "Don Mills"
          },
          :Leslie => {
            :google_maps_name => "Leslie",
            :id => 67,
            :latitude => 43.770847,
            :longitude => -79.36779,
            :name => "Leslie"
          },
          :"Sheppard-Yonge" => {
            :id => 64,
            :latitude => 123,
            :longitude => 456,
            :name => "Sheppard-Yonge"
          }
        }
      },
      :"Yonge-University-Spadina" => {
        :id => 1,
        :name => "Yonge-University-Spadina",
        :stations => {
          :"Bloor-Yonge" => {
            :google_maps_name => "Bloor-Yonge Station",
            :id => 22,
            :latitude => 43.6709058,
            :longitude => -79.38563719999999,
            :name => "Bloor-Yonge"
          },
          :College => {
            :google_maps_name => "College",
            :id => 20,
            :latitude => 43.6613247,
            :longitude => -79.3830746,
            :name => "College"
          },
          :Davisville => {
            :id => 26,
            :latitude => 123,
            :longitude => 456,
            :name => "Davisville",
            google_maps_name: 'Davisville'
          },
          :"Downsview Park" => {
            :google_maps_name => "Downsview Park",
            :id => 75,
            :latitude => 43.7535804,
            :longitude => -79.47881430000001,
            :name => "Downsview Park"
          },
          :Dundas => {
            :google_maps_name => "Dundas Station",
            :id => 19,
            :latitude => 123,
            :longitude => 456,
            :name => "Dundas"
          },
          :Dupont => {
            :google_maps_name => "Dupont Station",
            :id => 8,
            :latitude => 43.67485509999999,
            :longitude => -79.40708099999999,
            :name => "Dupont"
          },
          :Eglinton => {
            :id => 27,
            :latitude => 123,
            :longitude => 456,
            :name => "Eglinton"
          },
          :"Eglinton West" => {
            :google_maps_name => "Eglinton West",
            :id => 6,
            :latitude => 43.6993703,
            :longitude => -79.4361468,
            :name => "Eglinton West"
          },
          :Finch => {
            :id => 32,
            :latitude => 123,
            :longitude => 456,
            :name => "Finch",
            google_maps_name: 'Finch'
          },
          :"Finch West" => {
            :google_maps_name => "Finch West Station",
            :id => 76,
            :latitude => 43.7651403,
            :longitude => -79.4910434,
            :name => "Finch West"
          },
          :Glencairn => {
            :google_maps_name => "Glencairn",
            :id => 5,
            :latitude => 43.7094806,
            :longitude => -79.4411987,
            :name => "Glencairn"
          },
          :"Highway 407" => {
            :google_maps_name => "Highway 407",
            :id => 79,
            :latitude => 43.783215,
            :longitude => -79.52374789999999,
            :name => "Highway 407"
          },
          :King => {
            :google_maps_name => "King Station",
            :id => 17,
            :latitude => 43.6491523,
            :longitude => -79.37785989999999,
            :name => "King"
          },
          :Lawrence => {
            :id => 28,
            :latitude => 123,
            :longitude => 456,
            :name => 'Lawrence',
            google_maps_name: 'Lawrence Station'
          },
          :"Lawrence West" => {
            :id => 4,
            :latitude => 123,
            :longitude => 456,
            :name => "Lawrence West",
            google_maps_name: 'Lawrence West Station'
          },
          :Museum => {
            :google_maps_name => "Museum Station",
            :id => 11,
            :latitude => 43.6671421,
            :longitude => -79.3935868,
            :name => "Museum"
          },
          :"North York Centre" => {
            :google_maps_name => "North York Centre",
            :id => 31,
            :latitude => 43.7686866,
            :longitude => -79.41254599999999,
            :name => "North York Centre"
          },
          :Osgoode => {
            :google_maps_name => "Osgoode Station",
            :id => 14,
            :latitude => 43.65061439999999,
            :longitude => -79.38683139999999,
            :name => "Osgoode"
          },
          :"Pioneer Village" => {
            :google_maps_name => "Pioneer Village",
            :id => 78,
            :latitude => 43.7771693,
            :longitude => -79.5103292,
            :name => "Pioneer Village"
          },
          :Queen => {
            :google_maps_name => "Queen Station",
            :id => 18,
            :latitude => 43.6523969,
            :longitude => -79.3792228,
            :name => "Queen"
          },
          :"Queen's Park" => {
            :google_maps_name => "Queen's Park Station",
            :id => 12,
            :latitude => 43.6598804,
            :longitude => -79.3904768,
            :name => "Queen's Park"
          },
          :Rosedale => {
            :id => 23,
            :latitude => 123,
            :longitude => 456,
            :name => "Rosedale"
          },
          :"Sheppard West" => {
            :google_maps_name => "Sheppard West",
            :id => 1,
            :latitude => 43.74969129999999,
            :longitude => -79.4618986,
            :name => "Sheppard West"
          },
          :"Sheppard-Yonge" => {
            :id => 30,
            :latitude => 123,
            :longitude => 456,
            :name => "Sheppard-Yonge"
          },
          :Spadina => {
            :google_maps_name => "Spadina Station",
            :id => 9,
            :latitude => 43.6673525,
            :longitude => -79.40383469999999,
            :name => "Spadina"
          },
          :"St. Andrew" => {
            :google_maps_name => "St Andrew",
            :id => 15,
            :latitude => 43.6476574,
            :longitude => -79.3848079,
            :name => "St. Andrew"
          },
          :"St. Clair" => {
            :google_maps_name => "St Clair",
            :id => 25,
            :latitude => 43.6874845,
            :longitude => -79.3930467,
            :name => "St. Clair"
          },
          :"St. Clair West" => {
            :id => 7,
            :latitude => 123,
            :longitude => 456,
            :name => "St. Clair West",
            google_maps_name: 'St Clair West'
          },
          :"St. George" => {
            :id => 10,
            :latitude => 123,
            :longitude => 456,
            :name => "St. George"
          },
          :"St. Patrick" => {
            :google_maps_name => "St Patrick",
            :id => 13,
            :latitude => 43.6548307,
            :longitude => -79.38834849999999,
            :name => "St. Patrick"
          },
          :Summerhill => {
            :google_maps_name => "Summerhill",
            :id => 24,
            :latitude => 43.6822899,
            :longitude => -79.3907744,
            :name => "Summerhill"
          },
          :Union => {
            :google_maps_name => "Union Station",
            :id => 16,
            :latitude => 43.6452239,
            :longitude => -79.380861,
            :name => "Union"
          },
          :"Vaughan Metropolitan Centre" => {
            :google_maps_name => "Vaughan Metropolitan Centre",
            :id => 80,
            :latitude => 43.7942439,
            :longitude => -79.5274867,
            :name => "Vaughan Metropolitan Centre"
          },
          :Wellesley => {
            :id => 21,
            :latitude => 123,
            :longitude => 456,
            :name => "Wellesley"
          },
          :Wilson => {
            :id => 2,
            :latitude => 123,
            :longitude => 456,
            :name => "Wilson"
          },
          :"York University" => {
            :google_maps_name => "York University",
            :id => 77,
            :latitude => 43.7739092,
            :longitude => -79.4998269,
            :name => "York University"
          },
          :"York mills" => {
            :id => 29,
            :latitude => 123,
            :longitude => 456,
            :name => "York mills"
          },
          :Yorkdale => {
            :id => 3,
            :latitude => 123,
            :longitude => 456,
            :name => "Yorkdale",
            google_maps_name: 'Yorkdale Station'
          }
        }
      }
    }.freeze
  end
end

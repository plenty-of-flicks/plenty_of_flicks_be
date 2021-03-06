require 'rails_helper'

describe 'Groups API' do
  it 'can create a group' do
    group_params = ({
      name: 'Motley J'
    })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/groups", headers: headers, params: JSON.generate(group_params)

    json = JSON.parse(response.body, symbolize_names:true)

    group = Group.last

    expect(response).to be_successful
    expect(group).to be_a(Group)
    expect(group.name).to eq('Motley J')
    expect(json).to have_key(:data)
    expect(json[:data]).to be_a(Hash)
    expect(json[:data]).to have_key(:id)
    expect(json[:data][:id]).to eq(group.id.to_s)
    expect(json[:data]).to have_key(:type)
    expect(json[:data][:type]).to eq('group')
    expect(json[:data]).to have_key(:attributes)
    expect(json[:data][:attributes]).to be_a(Hash)
    expect(json[:data][:attributes]).to have_key(:name)
    expect(json[:data][:attributes][:name]).to eq(group.name)
    expect(json[:data][:attributes]).to have_key(:id)
    expect(json[:data][:attributes][:id]).to eq(group.id)
    expect(json[:data][:attributes]).to have_key(:users)
    expect(json[:data][:attributes][:users]).to eq([])
  end

  it 'can delete a group' do
    group = Group.create(
      name: 'Motley J'
    )

    expect(Group.count).to eq(1)

    delete "/api/v1/groups/#{group.id}"

    expect(response).to be_successful
    expect(Group.count).to eq(0)
    expect{Group.find(group.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can show all groups for a user' do
    nick = User.create(
      uid: '12345678910',
      email: 'nickmaxking@gmail.com',
      first_name: 'Nick',
      last_name: 'King',
      image: 'https://lh6.googleusercontent.com/-hEH5aK9fmMI/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucntLnugtaOVsqmvJGm89fFbDJ6GaQ/s96-c/photo.jpg'
    )
    fantastic_four = Group.create(
      name: 'Fantastic Four'
    )
    avengers = Group.create(
      name: 'The Avengers'
    )
    x_men = Group.create(
      name: 'X Men'
    )
    UserGroup.create(
      user: nick,
      group: fantastic_four
    )
    UserGroup.create(
      user: nick,
      group: x_men
    )

    get "/api/v1/users/#{nick.id}/groups"

    json = JSON.parse(response.body, symbolize_names:true)

    expect(response).to be_successful
    expect(json).to be_an(Array)
    expect(json.length).to eq(2)

    expect(json[0]).to be_a(Hash)
    expect(json[0]).to have_key(:data)
    expect(json[0][:data]).to be_a(Hash)
    expect(json[0][:data]).to have_key(:id)
    expect(json[0][:data][:id]).to eq(fantastic_four.id.to_s)
    expect(json[0][:data]).to have_key(:type)
    expect(json[0][:data][:type]).to eq('group')
    expect(json[0][:data]).to have_key(:attributes)
    expect(json[0][:data][:attributes]).to be_a(Hash)
    expect(json[0][:data][:attributes]).to have_key(:id)
    expect(json[0][:data][:attributes][:id]).to eq(fantastic_four.id)
    expect(json[0][:data][:attributes]).to have_key(:name)
    expect(json[0][:data][:attributes][:name]).to eq(fantastic_four.name)
    expect(json[0][:data][:attributes]).to have_key(:users)
    expect(json[0][:data][:attributes][:users]).to be_an(Array)
    expect(json[0][:data][:attributes][:users].length).to eq(1)
    expect(json[0][:data][:attributes][:users][0]).to be_an(Hash)
    expect(json[0][:data][:attributes][:users][0]).to have_key(:id)
    expect(json[0][:data][:attributes][:users][0][:id]).to eq(nick.id)
    expect(json[0][:data][:attributes][:users][0]).to have_key(:email)
    expect(json[0][:data][:attributes][:users][0][:email]).to eq(nick.email)
    expect(json[0][:data][:attributes][:users][0]).to have_key(:first_name)
    expect(json[0][:data][:attributes][:users][0][:first_name]).to eq(nick.first_name)
    expect(json[0][:data][:attributes][:users][0]).to have_key(:last_name)
    expect(json[0][:data][:attributes][:users][0][:last_name]).to eq(nick.last_name)
    expect(json[0][:data][:attributes][:users][0]).to have_key(:image)
    expect(json[0][:data][:attributes][:users][0][:image]).to eq(nick.image)
    expect(json[0][:data][:attributes][:users][0]).to have_key(:uid)
    expect(json[0][:data][:attributes][:users][0][:uid]).to eq(nick.uid)
    expect(json[0][:data][:attributes][:users][0]).to have_key(:created_at)
    expect(json[0][:data][:attributes][:users][0][:created_at]).to be_a(String)
    expect(json[0][:data][:attributes][:users][0]).to have_key(:updated_at)
    expect(json[0][:data][:attributes][:users][0][:updated_at]).to be_a(String)

    expect(json[1]).to be_a(Hash)
    expect(json[1]).to have_key(:data)
    expect(json[1][:data]).to be_a(Hash)
    expect(json[1][:data]).to have_key(:id)
    expect(json[1][:data][:id]).to eq(x_men.id.to_s)
    expect(json[1][:data]).to have_key(:type)
    expect(json[1][:data][:type]).to eq('group')
    expect(json[1][:data]).to have_key(:attributes)
    expect(json[1][:data][:attributes]).to be_a(Hash)
    expect(json[1][:data][:attributes]).to have_key(:id)
    expect(json[1][:data][:attributes][:id]).to eq(x_men.id)
    expect(json[1][:data][:attributes]).to have_key(:name)
    expect(json[1][:data][:attributes][:name]).to eq(x_men.name)
    expect(json[1][:data][:attributes]).to have_key(:users)
    expect(json[1][:data][:attributes][:users]).to be_an(Array)
    expect(json[1][:data][:attributes][:users].length).to eq(1)
    expect(json[1][:data][:attributes][:users][0]).to be_an(Hash)
    expect(json[1][:data][:attributes][:users][0]).to have_key(:id)
    expect(json[1][:data][:attributes][:users][0][:id]).to eq(nick.id)
    expect(json[1][:data][:attributes][:users][0]).to have_key(:email)
    expect(json[1][:data][:attributes][:users][0][:email]).to eq(nick.email)
    expect(json[1][:data][:attributes][:users][0]).to have_key(:first_name)
    expect(json[1][:data][:attributes][:users][0][:first_name]).to eq(nick.first_name)
    expect(json[1][:data][:attributes][:users][0]).to have_key(:last_name)
    expect(json[1][:data][:attributes][:users][0][:last_name]).to eq(nick.last_name)
    expect(json[1][:data][:attributes][:users][0]).to have_key(:image)
    expect(json[1][:data][:attributes][:users][0][:image]).to eq(nick.image)
    expect(json[1][:data][:attributes][:users][0]).to have_key(:uid)
    expect(json[1][:data][:attributes][:users][0][:uid]).to eq(nick.uid)
    expect(json[1][:data][:attributes][:users][0]).to have_key(:created_at)
    expect(json[1][:data][:attributes][:users][0][:created_at]).to be_a(String)
    expect(json[1][:data][:attributes][:users][0]).to have_key(:updated_at)
    expect(json[1][:data][:attributes][:users][0][:updated_at]).to be_a(String)
  end

  it 'can show a group by id' do
    nick = User.create(
      uid: '12345678910',
      email: 'nickmaxking@gmail.com',
      first_name: 'Nick',
      last_name: 'King',
      image: 'https://lh6.googleusercontent.com/-hEH5aK9fmMI/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucntLnugtaOVsqmvJGm89fFbDJ6GaQ/s96-c/photo.jpg'
    )
    ron = User.create(
      uid: '12345678910',
      email: 'ron@example.com',
      first_name: 'Ron',
      last_name: 'Swanson',
      image: 'https://lh6.googleusercontent.com/-hEH5aK9fmMI/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucntLnugtaOVsqmvJGm89fFbDJ6GaQ/s96-c/photo.jpg'
    )
    x_men = Group.create(
      name: 'X Men'
    )
    UserGroup.create(
      user: nick,
      group: x_men
    )
    UserGroup.create(
      user: ron,
      group: x_men
    )

    get "/api/v1/groups/#{x_men.id}"
    json = JSON.parse(response.body, symbolize_names:true)

    expect(response).to be_successful
    expect(json).to be_a(Hash)
    expect(json).to have_key(:data)
    expect(json[:data]).to be_a(Hash)
    expect(json[:data]).to have_key(:id)
    expect(json[:data][:id]).to eq(x_men.id.to_s)
    expect(json[:data]).to have_key(:type)
    expect(json[:data][:type]).to eq('group')
    expect(json[:data]).to have_key(:attributes)
    expect(json[:data][:attributes]).to be_a(Hash)
    expect(json[:data][:attributes]).to have_key(:id)
    expect(json[:data][:attributes][:id]).to eq(x_men.id)
    expect(json[:data][:attributes]).to have_key(:name)
    expect(json[:data][:attributes][:name]).to eq(x_men.name)
    expect(json[:data][:attributes]).to have_key(:users)
    expect(json[:data][:attributes][:users]).to be_an(Array)
    expect(json[:data][:attributes][:users].length).to eq(2)
    expect(json[:data][:attributes][:users][0]).to be_an(Hash)
    expect(json[:data][:attributes][:users][0]).to have_key(:id)
    expect(json[:data][:attributes][:users][0][:id]).to eq(nick.id)
    expect(json[:data][:attributes][:users][0]).to have_key(:email)
    expect(json[:data][:attributes][:users][0][:email]).to eq(nick.email)
    expect(json[:data][:attributes][:users][0]).to have_key(:first_name)
    expect(json[:data][:attributes][:users][0][:first_name]).to eq(nick.first_name)
    expect(json[:data][:attributes][:users][0]).to have_key(:last_name)
    expect(json[:data][:attributes][:users][0][:last_name]).to eq(nick.last_name)
    expect(json[:data][:attributes][:users][0]).to have_key(:image)
    expect(json[:data][:attributes][:users][0][:image]).to eq(nick.image)
    expect(json[:data][:attributes][:users][0]).to have_key(:uid)
    expect(json[:data][:attributes][:users][0][:uid]).to eq(nick.uid)
    expect(json[:data][:attributes][:users][0]).to have_key(:created_at)
    expect(json[:data][:attributes][:users][0][:created_at]).to be_a(String)
    expect(json[:data][:attributes][:users][0]).to have_key(:updated_at)
    expect(json[:data][:attributes][:users][0][:updated_at]).to be_a(String)
    expect(json[:data][:attributes][:users][1]).to be_an(Hash)
    expect(json[:data][:attributes][:users][1]).to have_key(:id)
    expect(json[:data][:attributes][:users][1][:id]).to eq(ron.id)
    expect(json[:data][:attributes][:users][1]).to have_key(:email)
    expect(json[:data][:attributes][:users][1][:email]).to eq(ron.email)
    expect(json[:data][:attributes][:users][1]).to have_key(:first_name)
    expect(json[:data][:attributes][:users][1][:first_name]).to eq(ron.first_name)
    expect(json[:data][:attributes][:users][1]).to have_key(:last_name)
    expect(json[:data][:attributes][:users][1][:last_name]).to eq(ron.last_name)
    expect(json[:data][:attributes][:users][1]).to have_key(:image)
    expect(json[:data][:attributes][:users][1][:image]).to eq(ron.image)
    expect(json[:data][:attributes][:users][1]).to have_key(:uid)
    expect(json[:data][:attributes][:users][1][:uid]).to eq(ron.uid)
    expect(json[:data][:attributes][:users][1]).to have_key(:created_at)
    expect(json[:data][:attributes][:users][1][:created_at]).to be_a(String)
    expect(json[:data][:attributes][:users][1]).to have_key(:updated_at)
    expect(json[:data][:attributes][:users][1][:updated_at]).to be_a(String)
  end

  it 'can retreive all movie matches for a group' do
    nick = User.create(
      uid: '12345678910',
      email: 'nick@example.com',
      first_name: 'Nick',
      last_name: 'King',
      image: 'https://lh6.googleusercontent.com/-hEH5aK9fmMI/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucntLnugtaOVsqmvJGm89fFbDJ6GaQ/s96-c/photo.jpg'
    )
    ron = User.create(
      uid: '12345678910',
      email: 'ron@example.com',
      first_name: 'Ron',
      last_name: 'Swanson',
      image: 'https://lh6.googleusercontent.com/-hEH5aK9fmMI/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucntLnugtaOVsqmvJGm89fFbDJ6GaQ/s96-c/photo.jpg'
    )
    tom = User.create(
      uid: '12345678910',
      email: 'tom@example.com',
      first_name: 'Tom',
      last_name: 'Haverford',
      image: 'https://lh6.googleusercontent.com/-hEH5aK9fmMI/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucntLnugtaOVsqmvJGm89fFbDJ6GaQ/s96-c/photo.jpg'
    )
    austin_powers = Movie.create(
      title: 'Austin Powers: International Man of Mystery',
      tmdb_id: 816,
      poster_path: '/1PkGnyFwRyapmbuILIOXXxiSh7Y.jpg',
      description: "As a swingin' fashion photographer by day and a groovy British superagent by night, Austin Powers is the '60s' most shagadelic spy, baby! But can he stop megalomaniac Dr. Evil after the bald villain freezes himself and unthaws in the '90s? With the help of sexy sidekick Vanessa Kensington, he just might.",
      vote_average: 6.5,
      vote_count: 2349,
      year: '1997'
    )
    comedy = austin_powers.genres.create(
      name: 'Comedy',
      tmdb_id: 14
    )
    action = austin_powers.genres.create(
      name: 'Action',
      tmdb_id: 16
    )
    nightcrawler = Movie.create(
      title: 'Nightcrawler',
      tmdb_id: 242582,
      poster_path: '/j9HrX8f7GbZQm1BrBiR40uFQZSb.jpg',
      description: 'When Lou Bloom, desperate for work, muscles into the world of L.A. crime journalism, he blurs the line between observer and participant to become the star of his own story. Aiding him in his effort is Nina, a TV-news veteran.',
      vote_average: 7.7,
      vote_count: 8018,
      year: '2014'
    )
    thriller = nightcrawler.genres.create(
      name: 'Thriller',
      tmdb_id: 11
    )
    theory_of_everything = Movie.create(
      title: 'The Theory of Everything',
      tmdb_id: 266856
    )
    x_men = Group.create(
      name: 'X Men'
    )
    netflix = Service.create(
      name: 'Netflix',
      watchmode_id: 203,
      logo: 'netflix_logo.png'
    )
    hulu = Service.create(
      name: 'Hulu',
      watchmode_id: 157,
      logo: 'hulu_logo.jpeg'
    )
    MovieAvailability.create(
      movie: austin_powers,
      service: netflix
    )
    MovieAvailability.create(
      movie: austin_powers,
      service: hulu
    )
    MovieAvailability.create(
      movie: nightcrawler,
      service: netflix
    )
    UserGroup.create(
      user: nick,
      group: x_men
    )
    UserGroup.create(
      user: ron,
      group: x_men
    )
    UserGroup.create(
      user: tom,
      group: x_men
    )
    Swipe.create(
      movie: austin_powers,
      user: nick,
      rating: 1
    )
    Swipe.create(
      movie: austin_powers,
      user: ron,
      rating: 1
    )
    Swipe.create(
      movie: austin_powers,
      user: tom,
      rating: 1
    )
    Swipe.create(
      movie: nightcrawler,
      user: nick,
      rating: 1
    )
    Swipe.create(
      movie: nightcrawler,
      user: ron,
      rating: 1
    )
    Swipe.create(
      movie: nightcrawler,
      user: tom,
      rating: 1
    )
    Swipe.create(
      movie: theory_of_everything,
      user: nick,
      rating: 1
    )
    Swipe.create(
      movie: theory_of_everything,
      user: ron,
      rating: 0
    )

    get "/api/v1/groups/#{x_men.id}/matches"
    json = JSON.parse(response.body, symbolize_names:true)

    expect(response).to be_successful
    expect(json).to be_a(Hash)
    expect(json).to have_key(:data)
    expect(json[:data]).to be_an(Array)
    expect(json[:data].length).to eq(2)
    expect(json[:data][0]).to be_a(Hash)
    expect(json[:data][0]).to have_key(:id)
    expect(json[:data][0][:id]).to eq(austin_powers.id.to_s)
    expect(json[:data][0]).to have_key(:type)
    expect(json[:data][0][:type]).to eq('match')
    expect(json[:data][0]).to have_key(:attributes)
    expect(json[:data][0][:attributes]).to be_a(Hash)
    expect(json[:data][0][:attributes]).to have_key(:title)
    expect(json[:data][0][:attributes][:title]).to eq(austin_powers.title)
    expect(json[:data][0][:attributes]).to have_key(:tmdb_id)
    expect(json[:data][0][:attributes][:tmdb_id]).to eq(austin_powers.tmdb_id)
    expect(json[:data][0][:attributes]).to have_key(:poster_path)
    expect(json[:data][0][:attributes][:poster_path]).to eq(austin_powers.poster_path)
    expect(json[:data][0][:attributes]).to have_key(:description)
    expect(json[:data][0][:attributes][:description]).to eq(austin_powers.description)
    expect(json[:data][0][:attributes]).to have_key(:genres)
    expect(json[:data][0][:attributes][:genres]).to be_an(Array)
    expect(json[:data][0][:attributes][:genres].length).to eq(2)
    expect(json[:data][0][:attributes][:genres][0]).to be_a(Hash)
    expect(json[:data][0][:attributes][:genres][0]).to have_key(:id)
    expect(json[:data][0][:attributes][:genres][0][:id]).to eq(comedy.id)
    expect(json[:data][0][:attributes][:genres][0]).to have_key(:created_at)
    expect(json[:data][0][:attributes][:genres][0][:created_at]).to be_a(String)
    expect(json[:data][0][:attributes][:genres][0]).to have_key(:updated_at)
    expect(json[:data][0][:attributes][:genres][0][:updated_at]).to be_a(String)
    expect(json[:data][0][:attributes][:genres][0]).to have_key(:tmdb_id)
    expect(json[:data][0][:attributes][:genres][0][:tmdb_id]).to eq(comedy.tmdb_id)
    expect(json[:data][0][:attributes][:genres][1]).to be_a(Hash)
    expect(json[:data][0][:attributes][:genres][1]).to have_key(:id)
    expect(json[:data][0][:attributes][:genres][1][:id]).to eq(action.id)
    expect(json[:data][0][:attributes][:genres][1]).to have_key(:created_at)
    expect(json[:data][0][:attributes][:genres][1][:created_at]).to be_a(String)
    expect(json[:data][0][:attributes][:genres][1]).to have_key(:updated_at)
    expect(json[:data][0][:attributes][:genres][1][:updated_at]).to be_a(String)
    expect(json[:data][0][:attributes][:genres][1]).to have_key(:tmdb_id)
    expect(json[:data][0][:attributes][:genres][1][:tmdb_id]).to eq(action.tmdb_id)
    expect(json[:data][0][:attributes]).to have_key(:vote_count)
    expect(json[:data][0][:attributes][:vote_count]).to eq(austin_powers.vote_count)
    expect(json[:data][0][:attributes]).to have_key(:vote_average)
    expect(json[:data][0][:attributes][:vote_average]).to eq(austin_powers.vote_average)
    expect(json[:data][0][:attributes]).to have_key(:year)
    expect(json[:data][0][:attributes][:year]).to eq(austin_powers.year)
    expect(json[:data][0][:attributes]).to have_key(:services)
    expect(json[:data][0][:attributes][:services]).to be_an(Array)
    expect(json[:data][0][:attributes][:services].length).to eq(2)
    expect(json[:data][0][:attributes][:services][0]).to be_a(Hash)
    expect(json[:data][0][:attributes][:services][0]).to have_key(:id)
    expect(json[:data][0][:attributes][:services][0][:id]).to eq(netflix.id)
    expect(json[:data][0][:attributes][:services][0]).to have_key(:name)
    expect(json[:data][0][:attributes][:services][0][:name]).to eq(netflix.name)
    expect(json[:data][0][:attributes][:services][0]).to have_key(:watchmode_id)
    expect(json[:data][0][:attributes][:services][0][:watchmode_id]).to eq(netflix.watchmode_id)
    expect(json[:data][0][:attributes][:services][0]).to have_key(:created_at)
    expect(json[:data][0][:attributes][:services][0][:created_at]).to be_a(String)
    expect(json[:data][0][:attributes][:services][0]).to have_key(:updated_at)
    expect(json[:data][0][:attributes][:services][0][:updated_at]).to be_a(String)
    expect(json[:data][0][:attributes][:services][0]).to have_key(:logo)
    expect(json[:data][0][:attributes][:services][0][:logo]).to eq(netflix.logo)
    expect(json[:data][0][:attributes][:services][1]).to be_a(Hash)
    expect(json[:data][0][:attributes][:services][1]).to have_key(:id)
    expect(json[:data][0][:attributes][:services][1][:id]).to eq(hulu.id)
    expect(json[:data][0][:attributes][:services][1]).to have_key(:name)
    expect(json[:data][0][:attributes][:services][1][:name]).to eq(hulu.name)
    expect(json[:data][0][:attributes][:services][1]).to have_key(:watchmode_id)
    expect(json[:data][0][:attributes][:services][1][:watchmode_id]).to eq(hulu.watchmode_id)
    expect(json[:data][0][:attributes][:services][1]).to have_key(:created_at)
    expect(json[:data][0][:attributes][:services][1][:created_at]).to be_a(String)
    expect(json[:data][0][:attributes][:services][1]).to have_key(:updated_at)
    expect(json[:data][0][:attributes][:services][1][:updated_at]).to be_a(String)
    expect(json[:data][0][:attributes][:services][1]).to have_key(:logo)
    expect(json[:data][0][:attributes][:services][1][:logo]).to eq(hulu.logo)

    expect(json[:data][1]).to be_a(Hash)
    expect(json[:data][1]).to have_key(:id)
    expect(json[:data][1][:id]).to eq(nightcrawler.id.to_s)
    expect(json[:data][1]).to have_key(:type)
    expect(json[:data][1][:type]).to eq('match')
    expect(json[:data][1]).to have_key(:attributes)
    expect(json[:data][1][:attributes]).to be_a(Hash)
    expect(json[:data][1][:attributes]).to have_key(:title)
    expect(json[:data][1][:attributes][:title]).to eq(nightcrawler.title)
    expect(json[:data][1][:attributes]).to have_key(:tmdb_id)
    expect(json[:data][1][:attributes][:tmdb_id]).to eq(nightcrawler.tmdb_id)
    expect(json[:data][1][:attributes]).to have_key(:poster_path)
    expect(json[:data][1][:attributes][:poster_path]).to eq(nightcrawler.poster_path)
    expect(json[:data][1][:attributes]).to have_key(:description)
    expect(json[:data][1][:attributes][:description]).to eq(nightcrawler.description)
    expect(json[:data][1][:attributes]).to have_key(:genres)
    expect(json[:data][1][:attributes][:genres]).to be_an(Array)
    expect(json[:data][1][:attributes][:genres].length).to eq(1)
    expect(json[:data][1][:attributes][:genres][0]).to be_a(Hash)
    expect(json[:data][1][:attributes][:genres][0]).to have_key(:id)
    expect(json[:data][1][:attributes][:genres][0][:id]).to eq(thriller.id)
    expect(json[:data][1][:attributes][:genres][0]).to have_key(:created_at)
    expect(json[:data][1][:attributes][:genres][0][:created_at]).to be_a(String)
    expect(json[:data][1][:attributes][:genres][0]).to have_key(:updated_at)
    expect(json[:data][1][:attributes][:genres][0][:updated_at]).to be_a(String)
    expect(json[:data][1][:attributes][:genres][0]).to have_key(:tmdb_id)
    expect(json[:data][1][:attributes][:genres][0][:tmdb_id]).to eq(thriller.tmdb_id)
    expect(json[:data][1][:attributes]).to have_key(:vote_count)
    expect(json[:data][1][:attributes][:vote_count]).to eq(nightcrawler.vote_count)
    expect(json[:data][1][:attributes]).to have_key(:vote_average)
    expect(json[:data][1][:attributes][:vote_average]).to eq(nightcrawler.vote_average)
    expect(json[:data][1][:attributes]).to have_key(:year)
    expect(json[:data][1][:attributes][:year]).to eq(nightcrawler.year)
    expect(json[:data][1][:attributes][:services]).to be_an(Array)
    expect(json[:data][1][:attributes][:services].length).to eq(1)
    expect(json[:data][1][:attributes][:services][0]).to be_a(Hash)
    expect(json[:data][1][:attributes][:services][0]).to have_key(:id)
    expect(json[:data][1][:attributes][:services][0][:id]).to eq(netflix.id)
    expect(json[:data][1][:attributes][:services][0]).to have_key(:name)
    expect(json[:data][1][:attributes][:services][0][:name]).to eq(netflix.name)
    expect(json[:data][1][:attributes][:services][0]).to have_key(:watchmode_id)
    expect(json[:data][1][:attributes][:services][0][:watchmode_id]).to eq(netflix.watchmode_id)
    expect(json[:data][1][:attributes][:services][0]).to have_key(:created_at)
    expect(json[:data][1][:attributes][:services][0][:created_at]).to be_a(String)
    expect(json[:data][1][:attributes][:services][0]).to have_key(:updated_at)
    expect(json[:data][1][:attributes][:services][0][:updated_at]).to be_a(String)
    expect(json[:data][1][:attributes][:services][0]).to have_key(:logo)
    expect(json[:data][1][:attributes][:services][0][:logo]).to eq(netflix.logo)
  end
end

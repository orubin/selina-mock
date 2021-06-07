import React from 'react';
import axios from 'axios';
import GoogleMapReact from 'google-map-react';
import Geocoder from 'react-native-geocoding';
import './Admin.css';

Geocoder.init('AIzaSyDxCfoKfjZjLCMX2gPTs2D8NfE1uGNXBac');

const ROOMPRICE = 120;
const ROOMNAME = 'DORM';

const Marker = (props) => {
    return (
      <button className="pin"/>
    );
  };

const RoomType = (props) => {
    return (
      <div>
        <div className="form-group">
          <label htmlFor="type">Type:</label>
          <select id={`type${props.index}`}>
            <option key="DORM">DORM</option>
            <option key="PRIVATE">PRIVATE</option>
            <option key="DELUXE">DELUXE</option>
          </select>
          <label htmlFor="price">Price:</label>
          <input className="form-control" type="text" id={`price${props.index}`} required/>
        </div>
      </div>
    );
  };

export default class Admin extends React.Component {
    
    /**
     * @param props
     */
    constructor(props) {
      super(props);
      this.state = {
        locations: this.props.locations,
        center: this.props.center,
        marker: {lat: 0.0, lng: 0.0},
        country: '',
        message: '',
        rooms: [{type: ROOMNAME, price: ROOMPRICE}]
      };
      this.locations = this.props.locations.map((item, key) =>
        <p key={item.name}>{item.name}</p>
      );
    }

    getCountry(addrComponents) {
      for (var i = 0; i < addrComponents.length; i++) {
          if (addrComponents[i].types[0] == "country") {
              return addrComponents[i].long_name;
          }
          if (addrComponents[i].types.length == 2) {
              if (addrComponents[i].types[0] == "political") {
                  return addrComponents[i].long_name;
              }
          }
      }
      return false;
    }

    changeMarker(lat, lng) {
        this.setState({marker: {lat: lat, lng: lng}});
        Geocoder.from(lat, lng)
        .then(json => {
            let country = this.getCountry(json.results[0].address_components)
            this.setState({country: country});
        })
        .catch(error => console.warn(error));
    }

    addLocation = (e) => {
      e.preventDefault();

      const data = {
        name: e.target.name.value,
        lat: this.state.marker.lat,
        lng: this.state.marker.lng,
        country: this.state.country
      };

      let rooms = [];

      for (var i = 0; i < this.state.rooms.length; i++) {
        rooms.push({
          type: e.target["type"+i].value,
          price: e.target["price"+i].value,
          guests_amount: 0
        });
      }

      data.rooms = rooms;
    
      const config = {
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-CSRF-Token': ReactOnRails.authenticityToken()
        }
      };
      
      axios.post('/api/v1/add_location', data, config).then((response) => {
        this.setState({message: response.data.message});
      });
    }

    addRow() {
      this.setState({rooms: this.state.rooms.concat({type: 'DORM', price: 120})});
    }

    render() {
        return (
          <div className="container">

            <h2>Current Locations:</h2>
            {this.locations}

            <hr />

            <h2>Add new location:</h2>
            <h4>Marker latitude: {this.state.marker.lat}, longitude: {this.state.marker.lng}</h4>

            <form onSubmit={(e) => this.addLocation(e)}>
              <div className="form-group">
                <label htmlFor="name">Name</label>
                <input className="form-control" type="text" id="name" required/>
              </div>

              <br></br>
              <h4>Rooms:</h4>
              {this.state.rooms.map((item, key) =>
                <RoomType key={key} type={item.type} price={item.price} index={key} />
              )}
              <br></br>
              
              <button className="plus-button" onClick={() => this.addRow()}>+</button>
              
              <div className="form-group">
                <button className="btn btn-primary" type="submit">Add location</button>
              </div>
            </form>

            <br/>
            <h2>{this.state.message}</h2>
            <div style={{ height: '100vh', width: '80%', margin: 'auto'}}>
              <GoogleMapReact
                bootstrapURLKeys={{ key: 'AIzaSyDxCfoKfjZjLCMX2gPTs2D8NfE1uGNXBac' }}
                defaultCenter={this.props.center}
                center={this.state.center}
                defaultZoom={this.props.zoom}
                onClick={(event) => {
                    this.changeMarker(event.lat, event.lng);
                }}
              >
                <Marker lat={this.state.marker.lat} lng={this.state.marker.lng}/>
              </GoogleMapReact>
            </div>
          </div>
        );
      }
}
import React from 'react';
import axios from 'axios';
import GoogleMapReact from 'google-map-react';
import './Locations.css';

const Marker = (props) => {
  const { color, name, text } = props;
  return (
    <button className="marker"
      style={{ backgroundColor: color, cursor: 'pointer'}}
      title={name}
      onClick={() => props.onClick(name)}
    >{text}</button>
  );
};

const ChosenLocation = (props) => {
  if (props.name === '' || props.rooms === '') {
    return ('');
  }
  return (<h2>{props.name} has {props.rooms} vacant rooms. <a href={"/order/" + props.id}>Book Now!</a></h2>);
}

export default class Locations extends React.Component {
  /**
   * @param props
   */
  constructor(props) {
    super(props);
    this.state = { 
      locations: this.props.locations,
      center: this.props.center,
      chosenLocation: '',
      chosenLocationRooms: '',
      chosenLocationId: 0
    };
    this.locations = this.props.locations.map((item, key) =>
      <button 
      className="button"
      key={item.name} 
      onClick={() => this.chooseLocation(item)}>
      {item.name}
      </button>
    );
    this.markers = this.props.locations.map((item, key) => 
      <Marker key={item.name} lat={item.lat} lng={item.lng} text={item.name} color="red" onClick={() => this.chooseLocation(item)}/>
    );
  }

  chooseLocation(location) {
    this.setState({ center: {lat: location.lat, lng: location.lng}, 
      chosenLocation: location.name, 
      chosenLocationRooms: location.available_rooms,
      chosenLocationId: location.id
    });
  }

  render() {
    return (
      <div className="container">
        <h1>
          Welcome to Selina!
        </h1>
        <h2>
          Check out one of our locations:
        </h2>
        <ul>{this.locations}</ul>

        <hr />
        <ChosenLocation name={this.state.chosenLocation} rooms={this.state.chosenLocationRooms} id={this.state.chosenLocationId}/>
        <hr />
        <div style={{ height: '100vh', width: '80%', margin: 'auto'}}>
          <GoogleMapReact
            bootstrapURLKeys={{ key: 'AIzaSyDxCfoKfjZjLCMX2gPTs2D8NfE1uGNXBac' }}
            defaultCenter={this.props.center}
            center={this.state.center}
            defaultZoom={this.props.zoom}
          >
            {this.markers}
          </GoogleMapReact>
        </div>
      </div>
    );
  }
}

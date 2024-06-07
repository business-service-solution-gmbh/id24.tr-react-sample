import React from 'react';
import {StyleSheet, View, Button} from 'react-native';
import {startIdentifySdk} from './src/utils/identifyUtils';

const App = () => {
  const startSdk = () =>
    startIdentifySdk({
      identificationId: 'df00e001be04b01d8916c3f5b20591781f827b18',
    });
  return (
    <View style={styles.sectionContainer}>
      <Button onPress={startSdk} title="open identify" />
    </View>
  );
};

const styles = StyleSheet.create({
  sectionContainer: {flex: 1, justifyContent: 'center', padding: '20%'},
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
  },
  highlight: {
    fontWeight: '700',
  },
});

export default App;

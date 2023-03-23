import './App.css';
import { Routes, Route } from 'react-router-dom';
import Login from './pages/Login';
import IndexPage from './pages/IndexPage';
import Layout from './Layout';
import Register from './pages/Register';
import axios from 'axios';
import { UserContextProvider } from './UserContext';
import AccountPage from './pages/AccountPage';
import EmployeeLogin from './pages/EmployeeLogin';

axios.defaults.baseURL = 'http://localhost:6060';
axios.defaults.withCredentials = true;

function App() {
  return (
    <UserContextProvider>
      <Routes>
        <Route path='/' element={<Layout/>}>
          <Route index element={<IndexPage/>} />
          <Route path="/login" element={<Login/>} />
          <Route path="/register" element={<Register/>} />
          <Route path="/employee_login" element={<EmployeeLogin/>}/>
          <Route path="/account/:subpage?/:subpage?" element={<AccountPage/>}/>
        </Route>
      </Routes>
    </UserContextProvider>
    
  );
}

export default App;

import * as React from 'react'
import { Link } from 'gatsby'

import Logo from './Logo'
import NavItem from './NavItem'
import DocSearch from './DocSearch'

const Header = () => (
  <header className="bb b--moon-gray">
    <div className="mw9 center pa3 flex items-center w-100">
      <Link to="/" className="link green db">
        <Logo />
      </Link>

      <DocSearch />

      <nav className="w-100 tr">
        <NavItem url="/api.html">Api</NavItem>
        <NavItem url="/developer.html">Developer</NavItem>
        <NavItem url="/user.html">User</NavItem>
        <NavItem url="/release_notes.html">Release-notes</NavItem>
        <NavItem url="http://slack.spreecommerce.org/">Slack</NavItem>
        <NavItem url="https://heroku.com/deploy?template=https://github.com/spree/spree">
          Demo
        </NavItem>
      </nav>
    </div>
  </header>
)

export default Header

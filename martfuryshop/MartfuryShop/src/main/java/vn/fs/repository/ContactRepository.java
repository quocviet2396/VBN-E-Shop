
package vn.fs.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.fs.entity.Contact;

@Repository
public interface ContactRepository extends JpaRepository<Contact, Long> {
}
